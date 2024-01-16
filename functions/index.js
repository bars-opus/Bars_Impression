const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const { Message } = require('firebase-functions/lib/providers/pubsub');
const {Storage} = require('@google-cloud/storage');
const firestore = admin.firestore();
const storage = new Storage();
const axios = require('axios');





// const PAYSTACK_SECRET_KEY = functions.config().paystack.secret_key; // Assuming you've set this in your environment config

// exports.createSubaccount = functions.https.onCall(async (data, context) => {
//   // Check if the user is authenticated
//   if (!context.auth) {
//     throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
//   }

//   const PAYSTACK_SECRET_KEY = functions.config().paystack.secret_key;


//   // Verify the bank account first
//   try {
//       // eslint-disable-next-line no-await-in-loop
//     const verificationResponse = await axios.get(`https://api.paystack.co/bank/resolve?account_number=${data.account_number}&bank_code=${data.bank_code}`, {
//       headers: {
//         Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
//       },
//     });

//     // Check if verification was successful
//     if (!verificationResponse.data.status) {
//       throw new functions.https.HttpsError('aborted', 'Bank account verification failed.');
//     }

//     // Bank account is verified, proceed with creating the subaccount
//     // eslint-disable-next-line no-await-in-loop
//     const paystackResponse = await axios.post('https://api.paystack.co/subaccount', {
//       business_name: data.business_name, 
//       settlement_bank: data.bank_code,   
//       account_number: data.account_number, 
//       percentage_charge: data.percentage_charge 
//     }, {
//       headers: {
//         Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
//         'Content-Type': 'application/json'
//       }
//     });

//     if (paystackResponse.data.status) {
//       // eslint-disable-next-line no-await-in-loop
      // const recipient_code = await createTransferRecipient(data, PAYSTACK_SECRET_KEY   )
//       return { subaccount_id: paystackResponse.data.data.subaccount_code, transferRecepientId: recipient_code};
//     } else {
//       // Failed to create subaccount
//       throw new functions.https.HttpsError('unknown', 'Failed to create subaccount with Paystack');
//     }
//   } catch (error) {
//     console.error('Detailed error:', {
//       message: error.message,
//       stack: error.stack,
//       response: error.response ? error.response.data : null,
//     });
//     throw new functions.https.HttpsError(
//       'unknown',
//       'Error creating subaccount',
//       error.response ? error.response.data : error.message
//     );
//   }
// });


exports.createSubaccount = functions.https.onCall(async (data, context) => {
  const PAYSTACK_SECRET_KEY = functions.config().paystack.secret_key;
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
  }

  try {
    const paystackResponse =  await axios.post('https://api.paystack.co/subaccount', {
      business_name: data.business_name, 
      settlement_bank: data.bank_code,   
      account_number: data.account_number, 
      percentage_charge: data.percentage_charge 
    }, {
      headers: {
        Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
        'Content-Type': 'application/json'
      }
    });

    if (paystackResponse.data.status) {
      // eslint-disable-next-line no-await-in-loop
      const recipient_code = await createTransferRecipient(data, PAYSTACK_SECRET_KEY);

      return { subaccount_id: paystackResponse.data.data.subaccount_code, recipient_code: recipient_code };
    } else {
      throw new functions.https.HttpsError('unknown', 'Failed to create subaccount with Paystack');
    }
  } catch (error) {
    console.error('Paystack subaccount creation error:', error);
    throw new functions.https.HttpsError('unknown', 'Paystack subaccount creation failed', error);
  }
});



// // Helper function to create a transfer recipient
async function createTransferRecipient(data, PAYSTACK_SECRET_KEY) {

  try {
    const response = await axios.post("https://api.paystack.co/transferrecipient", {
      type: "ghipss", // Adjust type as per your requirements
      name: data.business_name,
      account_number: data.account_number,
      bank_code: data.bank_code,
      currency: 'GHS',
    }, {
      headers: {
        Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
        'Content-Type': 'application/json'
      }
    });

    // Check if the status is true and the data object contains the recipient_code
    if (response.data.status && response.data.data && response.data.data.recipient_code) {
      return response.data.data.recipient_code;
    } else {
      // Provide more detailed error informationy
      const message = response.data.message || 'Failed to create transfer recipient with Paystack';
      console.error(message);
      throw new functions.https.HttpsError('unknown', message, response.data);
    }
  } catch (error) {
    console.error('Error creating transfer recipient:', error.response ? error.response.data : error);
    throw new functions.https.HttpsError(
      'unknown',
      'Error occurred while creating transfer recipient.',
      error.response ? error.response.data : error.message
    );
  }
}



async function deleteSubaccount(subaccountCode, PAYSTACK_SECRET_KEY) {
  try {
    await axios.delete(`https://api.paystack.co/subaccount/${subaccountCode}`, {
      headers: {
        Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
      },
    });
  } catch (error) {
    throw error;
  }
}




exports.verifyPaystackPayment = functions.https.onCall(async (data, context) => {
  // Ensure the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated to verify payment.');
  }

  const paymentReference = data.reference;
  const expectedAmount = data.amount; // The expected amount in kobo.
  const PAYSTACK_SECRET_KEY =functions.config().paystack.secret_key; // Securely stored Paystack secret key

  try {
    const verificationURL = `https://api.paystack.co/transaction/verify/${encodeURIComponent(paymentReference)}`;
                    // eslint-disable-next-line no-await-in-loop
    const response = await axios.get(verificationURL, {
      headers: { Authorization: `Bearer ${PAYSTACK_SECRET_KEY}` },
    });

    const paymentData = response.data.data;

    // Verify the amount paid is what you expect
    if (paymentData.status === 'success' && parseInt(paymentData.amount) === expectedAmount) {
      // Payment is successful and the amount matches
      // You can proceed to grant the service or update your database here
      // ...

      return { success: true, message: 'Payment verified successfully', transactionData: paymentData };
    } else {
      // Payment failed or the amount does not match
      return { success: false, message: 'Payment verification failed: Amount does not match or payment was unsuccessful.', transactionData: paymentData };
    }
  } catch (error) {
    // Handle errors
    console.error('Payment verification error:', error);
    // Return a sanitized error message to the client
    throw new functions.https.HttpsError('unknown', 'Payment verification failed. Please try again later.');
  }
});



// exports.verifyPaystackPayment = functions.https.onCall(async (data, context) => {
//   // Ensure the user is authenticated
//   if (!context.auth) {
//     throw new functions.https.HttpsError('unauthenticated', 
//       'User must be authenticated to verify payment.');
//   }

//   const paymentReference = data.reference;
//   const expectedAmount = data.amount; // The expected amount in kobo.

//   try {
//     const verificationURL = `https://api.paystack.co/transaction/verify/${encodeURIComponent(paymentReference)}`;
//     const response = await axios.get(verificationURL, {
//       headers: { Authorization: `Bearer ${PAYSTACK_SECRET_KEY}` },
//     });

//     const paymentData = response.data.data;

//     // Verify the amount paid is what you expect
//     if (paymentData.status === 'success' && parseInt(paymentData.amount) === expectedAmount) {
//       // Payment is successful and the amount matches
//       // You can proceed to grant the service or update your database here
//       // ...

//       return { success: true, message: 'Payment verified successfully' };
//     } else {
//       // Payment failed or the amount does not match
//       return { success: false, message: 'Payment verification failed: Amount does not match or payment was unsuccessful.' };
//     }
//   } catch (error) {
//     // Handle errors
//     console.error('Payment verification error:', error);
//     // Return a sanitized error message to the client
//     throw new functions.https.HttpsError('unknown', 'Payment verification failed. Please try again later.');
//   }
// });






function isRetryableError(error) {
  // Check for common network-related error codes
  if (['ETIMEDOUT', 'ECONNRESET'].includes(error.code)) {
    return true;
  }
  // Check for a network error message
  if (error.message && error.message.includes('Network Error')) {
    return true;
  }
  // Check for too many requests error (rate limiting)
  if (error.response && error.response.status === 429) {
    return true;
  }
  // Add other conditions for retryable errors as per your application logic
  // ...

  return false;
}


// Helper function to alert the admin by creating a Firestore document


// async function createTransferWithRetry(db, eventDoc, maxRetries = 3) {
//   let retryCount = 0;
//   let delay = 1000; // Initial delay in milliseconds (1 second)
//   const eventData = eventDoc.data();

//   while (retryCount < maxRetries) {
//     try {               
//        // eslint-disable-next-line no-await-in-loop
//       const organizerShare = await calculateOrganizerShare(eventData);
//     // eslint-disable-next-line no-await-in-loop
//       const response = await paystack.subaccount.createTransfer({
//         source: "balance",
//         reason: "organizer payment", 
//         amount: organizerShare,
//         recipient: eventData.subaccountId,
//       });

//       if (response.status) {
//         // Transfer was successful
//          // eslint-disable-next-line no-await-in-loop
//         await alertAdminFundsDistributedSuccess(db, eventDoc.id, eventData.subaccountId);
//         return response;
//       } else {
//         // Transfer failed without an exception, possibly a business logic error
//         throw new Error('Transfer failed with a non-success status');
//       }
//     } catch (error) {
//       console.error(`Attempt ${retryCount + 1} for event ${eventDoc.id} failed:`, error);

//       // Check if the error is retryable, if not, alert admin and stop retrying
//       if (!isRetryableError(error)) {
//          // eslint-disable-next-line no-await-in-loop
//         await alertAdminDistributeFundsError(db, eventDoc.id, eventData.subaccountId);
//         throw error; // Non-retryable error, rethrow error
//       }

//       // Log the retryable error and wait before the next attempt
//       console.log(`Retryable error encountered for event ${eventDoc.id}. Will retry after ${delay}ms...`);
//        // eslint-disable-next-line no-await-in-loop
//       await new Promise(resolve => setTimeout(resolve, delay));
      
//       // Increment the retry count and update the delay for exponential backoff
//       retryCount++;
//       delay *= 2;
//     }
//   }

  // If all retry attempts fail, alert admin and throw an error
   // eslint-disable-next-line no-await-in-loop
//   await alertAdminDistributeFundsError(db, eventDoc.id, eventData.subaccountId);
//   throw new Error(`All retry attempts failed for event ${eventDoc.id}`);
// }


// async function createTransferWithRetry(db, eventDoc, maxRetries = 3) {
//   let retryCount = 0;
//   let delay = 1000; // Initial delay in milliseconds (1 second)
//   const eventData = eventDoc.data();
//   // const paystackSecretKey = 'YOUR_SECRET_KEY'; // Replace with your actual secret key

//   while (retryCount < maxRetries) {
//     try {
//         // eslint-disable-next-line no-await-in-loop
//       const organizerShare = await calculateOrganizerShare(eventData);
//         // eslint-disable-next-line no-await-in-loop
//       const response = await fetch('https://api.paystack.co/transfer', {
//         method: 'POST',
//         headers: {
//           'Authorization': `Bearer ${functions.config().paystack.secret_key}`,
//           'Content-Type': 'application/json'
//         },
//         body: JSON.stringify({
//           source: "balance",
//           amount: organizerShare,
//           recipient: eventData.subaccountId,
//           reason: "Payment to organizer", // Add an appropriate reason for the transfer
//         })
//       });

//       if (!response.ok) {
//         throw new Error(`HTTP error: ${response.status} - ${response.statusText}`);
//       }
//   // eslint-disable-next-line no-await-in-loop
//       const responseData = await response.json();

//       if (responseData.status) {
//           // eslint-disable-next-line no-await-in-loop
//         await alertAdminFundsDistributedSuccess(db, eventDoc.id, eventData.subaccountId);
//         return responseData.data;
//       } else {
//         throw new Error('Transfer failed with a non-success status');
//       }
//     }
//     catch (error) {
//       console.error(`Attempt ${retryCount + 1} for event ${eventDoc.id} failed:`, error);
    
//       // Check if the error should not be retried
//       if (!isRetryableError(error)) {
//         // Log the original error message directly to the database
//          // eslint-disable-next-line no-await-in-loop
//         await alertAdminDistributeFundsError(db, eventDoc.id, eventData.subaccountId, error.message || "Unknown error");
//         throw error; // Rethrow the original error
//       }
//       // Log retryable error and delay next attempt
//       console.log(`Retryable error encountered for event ${eventDoc.id}. Will retry after ${delay}ms...`);
//        // eslint-disable-next-line no-await-in-loop
//       await new Promise(resolve => setTimeout(resolve, delay));
//       retryCount++;
//       delay *= 2;
//     }
   
//   }
//     // eslint-disable-next-line no-await-in-loop
//    await alertAdminDistributeFundsError(db, eventDoc.id, eventData.subaccountId, 'could bot procces funds');
//   throw new Error(`All ${maxRetries} retries failed for event ${eventDoc.id}`);
// }



async function createTransferWithRetry(db, eventDoc, maxRetries = 3) {
  let retryCount = 0;
  let delay = 1000; // Initial delay in milliseconds (1 second)
  const eventData = eventDoc.data();

  while (retryCount < maxRetries) {
    try {
         // eslint-disable-next-line no-await-in-loop
      const organizerShare = await calculateOrganizerShare(eventData);
   // eslint-disable-next-line no-await-in-loop
      const response = await axios.post('https://api.paystack.co/transfer', {
        source: "balance",
        amount: organizerShare,
        recipient: eventData.transferRecepientId,
        reason:  `Payment to organizer for :  ${ eventData.title}`, 
      }, {
        headers: {
          'Authorization': `Bearer ${functions.config().paystack.secret_key}`,
          'Content-Type': 'application/json'
          // 'Authorization': `Bearer ${functions.config().paystack.secret_key}`,
          // 'Content-Type': 'application/json'
        }
      });

      const responseData = response.data;

      if (responseData.status) {
           // eslint-disable-next-line no-await-in-loop
        await alertAdminFundsDistributedSuccess(db, eventDoc.id, eventData.subaccountId);
        return responseData.data;
      }else {
        // Handle known errors without retrying
        if (responseData.message.includes("Transfer code is invalid")) {
          // eslint-disable-next-line no-await-in-loop
          await alertAdminDistributeFundsError(db, eventDoc.id, eventData.organizerSubaccountId, responseData.message);
          throw new Error(responseData.message);
        }
        // Throw a generic error to trigger a retry for other cases
        throw new Error('Transfer failed with a non-success status');
      }
    
    } catch (error) {
      console.error(`Attempt ${retryCount + 1} for event ${eventDoc.id} failed:`, error);

      if (!isRetryableError(error)) {
           // eslint-disable-next-line no-await-in-loop
        await alertAdminDistributeFundsError(db, eventDoc.id, eventData.subaccountId, error.message || "Unknown error");
        throw error;
      }

      console.log(`Retryable error encountered for event ${eventDoc.id}. Will retry after ${delay}ms...`);
      // eslint-disable-next-line no-await-in-loop
      await new Promise(resolve => setTimeout(resolve, delay));
      retryCount++;
      delay *= 2;
    }
  }

  await alertAdminDistributeFundsError(db, eventDoc.id, eventData.subaccountId, 'could not process funds');
     // eslint-disable-next-line no-await-in-loop
  throw new Error(`All ${maxRetries} retries failed for event ${eventDoc.id}`);
}

exports.distributeEventFunds = functions.pubsub.schedule('every 5 minutes').onRun(async (context) => {
  const db = admin.firestore();
  
  // Assume this is where you fetch events from Firestore
  const eventsSnapshot = await db.collection('new_allEvents')
    .where('clossingDay', '<=', admin.firestore.Timestamp.now())
    .where('fundsDistributed', '==', false)
    .get();

  for (const eventDoc of eventsSnapshot.docs) {
    const eventId = eventDoc.id;
    const eventData = eventDoc.data();
    const idempotencyKey = `${eventId}_${new Date().toISOString().slice(0, 10)}`;
  
    const idempotencyDocRef = db.collection('idempotency_keys').doc(idempotencyKey);
    const eventDocRef = eventDoc.ref;
  
    try {
      // Start a transaction
       // eslint-disable-next-line no-await-in-loop
      await db.runTransaction(async (transaction) => {
        // Check for idempotency inside the transaction
        const idempotencyDoc = await transaction.get(idempotencyDocRef);
        if (idempotencyDoc.exists) {
          // Skip this event as it has already been processed
          return;
        }
  
        // Attempt to create the transfer with retries
         // eslint-disable-next-line no-await-in-loop
        const response = await createTransferWithRetry(db, eventDoc);
  
        // If the transfer is successful, mark the event as processed and store the idempotency key
        transaction.update(eventDocRef, { fundsDistributed: true });
        transaction.set(idempotencyDocRef, {
          transferResponse: response.data, // Assume the API response has a data field
          created: admin.firestore.FieldValue.serverTimestamp()
        });
      });
    } catch (error) {
      // If the transaction fails, log the error and alert the admin
      console.error(`Transaction failed for event ${eventId}:`, error);
       // eslint-disable-next-line no-await-in-loop
      await alertAdminDistributeFundsError(db, eventId, eventData.subaccountId, `Transaction failed for event: ${error}:` );
    }
  }
});

// async function alertAdminFundsDistributedSuccess(db, eventId, subaccountId, ) {
//   const successDoc = {
//     eventId: eventId,
//     subaccountId: subaccountId,
//     status: 'successful', 
//     date: admin.firestore.FieldValue.serverTimestamp()
//   };
//   await db.collection('distribute_funds_success').add(successDoc);
// }




// Example function to log success with more details
function alertAdminFundsDistributedSuccess(eventId, response) {
  // Sanitize the response to remove sensitive data
  const sanitizedResponse = sanitizeResponse(response);

  // Add additional logging information here
  const logEntry = {
    timestamp: new Date(),
    eventId: eventId,
    status: 'Success',
    response: sanitizedResponse // Log the sanitized response
  };

  // Save the log entry to Firebase
  const db = admin.firestore();
  db.collection('funds_distributed_success_logs').add(logEntry)
    .then(() => console.log('Logged success with additional details'))
    .catch(error => console.error('Error logging success:', error));
}




// Example function to log error with more details
function alertCalculateFundDistError(eventId, error, response) {
  // Sanitize the response to remove sensitive data
  const sanitizedResponse = sanitizeResponse(response);

  // Add additional logging information here
  const logEntry = {
    timestamp: new Date(),
    eventId: eventId,
    status: 'Error',
    error: error.toString(), // Log the error message
    response: sanitizedResponse // Log the sanitized response
  };

  // Save the log entry to Firebase
  const db = admin.firestore();
  db.collection('fund_distribution_error_logs').add(logEntry)
    .then(() => console.log('Logged error with additional details'))
    .catch(error => console.error('Error logging error:', error));
}

// Function to sanitize the response
function sanitizeResponse(response) {
  // Create a copy to avoid mutating the original response
  let sanitized = Object.assign({}, response);

  // Remove or mask sensitive fields
  if (sanitized.data && sanitized.data.customer && sanitized.data.customer.email) {
    sanitized.data.customer.email = 'REDACTED'; // Example of data redaction
  }

  // Add more fields to redact as necessary based on the structure of your response

  return sanitized;
}
// async function alertAdminDistributeFundsError(db, eventId, subaccountId, error) {
//   const failureDoc = {
//     eventId: eventId,
//     subaccountId: subaccountId,
//     error: error,
//     date: admin.firestore.FieldValue.serverTimestamp()
//   };
  
//   await db.collection('distribute_funds_failures').add(failureDoc);
// }



// async function alertCalculateFundDistError(db, eventId, subaccountId, errorMessage) {
//   const failureDoc = {
//     eventId: eventId,
//     errorMessage: errorMessage, 
//     subaccountId: subaccountId,
//     date: admin.firestore.FieldValue.serverTimestamp()
//   }; 
 
//   await db.collection('calculate_funds_failures').add(failureDoc);
// }

async function calculateOrganizerShare(eventData) {
  try {
    // Initialize a variable to hold the sum of all ticket totals
    let totalAmountCollected = 0;

    // Get a reference to the subcollection
    const ticketOrderCollection = admin.firestore()
      .collection('new_eventTicketOrder')
      .doc(eventData.id)
      .collection('eventInvite');

    // Retrieve the snapshot
    const totalTicketSnapshot = await ticketOrderCollection.get();

    // Check if there are any ticket orders
    if (totalTicketSnapshot.empty) {
      console.log(`No ticket orders found for event: ${eventData.id}`);
      // Handle the scenario where there are no ticket orders, e.g., return 0 or throw an error
      return 0; // Assuming the organizer's share is zero if there are no ticket sales
    }

    // Loop through each document in the snapshot
    for (const eventDoc of totalTicketSnapshot.docs) {
      // Accumulate the total amount from each ticket order
      // Ensure that the total is a number and not undefined or null
      const ticketTotal = eventDoc.data().total;
      if (typeof ticketTotal === 'number') {
        totalAmountCollected += ticketTotal;
      } else {
        // Handle the scenario where ticket total is not a number
         // eslint-disable-next-line no-await-in-loop
        await alertCalculateFundDistError(db, eventData.id, eventData.subaccountId, `Invalid ticket total for document: ${String(ticketTotal)}` );
        console.error(`Invalid ticket total for document: ${eventDoc.id}`);
        // Depending on your error handling strategy, you can throw an error or skip this ticket total
        // throw new Error(`Invalid ticket total for document: ${eventDoc.id}`);
      }
    }

    // Calculate your commission (10% of the total amount)
    const commissionRate = 0.10; // 10% commission rate
    const commission = totalAmountCollected * commissionRate;

    // The organizer's share is the remaining 90%
    const organizerShare = totalAmountCollected - commission;

    // Ensure the organizer's share is not negative
    if (organizerShare < 0) {
      throw new Error('Calculated organizer share is negative, which is not possible.');
    }

    // Return the organizer's share
    return Math.round(organizerShare * 100);

    // return organizerShare;

  } catch (error) {
    // Use eventData.id instead of eventDoc.id to avoid referencing an undefined variable
    await alertCalculateFundDistError(db, eventData.id, eventData.subaccountId, `Error calculating organizer share: ${error.message.toString()}` );
    console.error('Error calculating organizer share:', error);
    throw error;
  }
}




// //Note
// //i have a create a refund functoin so users can use to refund already purchase tickets.
// //it should have a collection with events and their refunds.
// // Cloud Function to distribute event funds

// exports.scheduledRefundProcessor = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
//   const db = admin.firestore();
//   const refundRequestsSnapshot = await db.collection('refundRequests').where('status', '==', 'pending').get();

//   for (const refundRequestDoc of refundRequestsSnapshot.docs) {
//     try {
//       await processRefund(refundRequestDoc);
//     } catch (error) {
//       console.error(`Error processing refund for transaction ID: ${refundRequestDoc.id}`, error);
//       await alertAdminRefundSuccess(db, refundRequestDoc.data().eventId, refundRequestDoc.id, error.message);
//     }
//   }
// });

// async function processRefund(refundRequestDoc) {
//   const db = admin.firestore(); // Ensure that 'admin' is initialized and 'db' is in scope.
//   const refundData = refundRequestDoc.data();
//   const transactionId = refundData.transactionId;
//   const eventId = refundData.eventId;
//   const refundAmount = Math.floor(refundData.amount * 0.80); // 80% of the original amount
//   const idempotencyKey = `refund_${transactionId}`;

//   const payload = {
//     transaction: transactionId,
//     amount: refundAmount
//   };

//   const headers = {
//     'Authorization': `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
//     'Content-Type': 'application/json'
//   };

//   let retryCount = 0;
//   let delay = 1000; // 1 second initial delay
//   const maxRetries = 3;

//   while (retryCount < maxRetries) {
//     try {
//       const response = await axios.post('https://api.paystack.co/refund', payload, { headers });

//       if (response.data.status) {
//         await db.runTransaction(async (transaction) => {
//           const refundRequestRef = refundRequestDoc.ref;
//           const idempotencyDocRef = db.collection('idempotency_keys').doc(idempotencyKey);
//           const idempotencyDocSnapshot = await transaction.get(idempotencyDocRef);

//           if (!idempotencyDocSnapshot.exists) {
//             transaction.update(refundRequestRef, { status: 'processed' });
//             transaction.set(idempotencyDocRef, {
//               refundResponse: response.data,
//               created: admin.firestore.FieldValue.serverTimestamp()
//             });
//           } else {
//             console.log(`Refund already processed for transaction ID: ${transactionId}`);
//             return;
//           }
//         });
//         await alertAdminRefundSuccess(db, eventId, transactionId); // Pass 'db' to these functions.
//         console.log(`Refund processed for transaction ID: ${transactionId}`);
//         return;
//       } else {
//         throw new Error('Refund failed with a non-success status');
//       }
//     } catch (error) {
//       console.error(`Attempt ${retryCount + 1} for refund ${transactionId} failed:`, error);

//       if (!isRetryableError(error)) {
//         await refundRequestDoc.ref.update({ status: 'error' }); // This update could also be in a transaction.
//         await alertAdminRefundFialure(db, eventId, transactionId,  error.message);
//         throw error; // Non-retryable error, rethrow error
//       }

//       if (retryCount === maxRetries - 1) {
//         await alertAdminRefundFialure(db, eventId, transactionId, `Max retry attempts reached. Last error: ${error.message}`);
//       }


//       console.log(`Retryable error encountered for refund ${transactionId}. Retrying after ${delay}ms...`);
//       await new Promise(resolve => setTimeout(resolve, delay));
//       retryCount++;
//       delay *= 2; // Exponential backoff
//     }
//   }

//   await refundRequestDoc.ref.update({ status: 'failed' }); // This update could also be in a transaction.
//   await alertAdminRefundFialure(db, eventId, transactionId, 'All refund requst failed');
//   throw new Error(`All retry attempts failed for refund ${transactionId}`);
// }




//   async function alertAdminRefundFialure(db, eventId, transactionId, errorMessage) {
//     const failureDoc = {
//       eventId: eventId,
//       transactionId: transactionId,
//       error: errorMessage, 
//       date: admin.firestore.FieldValue.serverTimestamp()
//     };
//     await db.collection('refund_failures').add(failureDoc);
//   }
  

//   async function alertAdminRefundSuccess(db, eventId, transactionId,) {
//     const successDoc = {
//       eventId: eventId,
//       status: 'succesful', 
//       transactionId: transactionId,
//       date: admin.firestore.FieldValue.serverTimestamp()
//     };
//     await db.collection('refund_success').add(successDoc);
//   }
  
  

exports.scheduledRefundProcessor = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
   // eslint-disable-next-line no-await-in-loop
   const db = admin.firestore();

  const refundRequestsSnapshot = await db.collection('allRefundRequests').where('status', '==', 'pending').get();

  for (const refundRequestDoc of refundRequestsSnapshot.docs) {
    try { // eslint-disable-next-line no-await-in-loop
      await processRefund(refundRequestDoc);
    } catch (error) {
      console.error(`Error processing refund for transaction ID: ${refundRequestDoc.id}`, error);
      // Handle the error appropriately, e.g., alert the admin
       // eslint-disable-next-line no-await-in-loop
      await alertAdminRefundFailure(db, refundRequestDoc.data().eventId, refundRequestDoc.data().transactionId, error.message);
    }
  }
});

async function processRefund(refundRequestDoc) {
  const db = admin.firestore();

  const refundData = refundRequestDoc.data();
  const transactionId = refundData.transactionId;
  const eventId = refundData.eventId;
  const refundAmount = Math.floor(refundData.amount * 0.80); // 80% of the original amount
  const idempotencyKey = `refund_${transactionId}`;

  const payload = {
    transaction: transactionId,
    amount: refundAmount
  };

  const headers = {
    'Authorization': `Bearer ${functions.config().paystack.secret_key}`,
    'Content-Type': 'application/json'
  };

  let retryCount = 0;
  let delay = 1000; // 1 second initial delay
  const maxRetries = 3;
  const MAX_DELAY = 30000; // Maximum delay for exponential backoff, e.g., 30 seconds

  while (retryCount < maxRetries) {
    try {
       // eslint-disable-next-line no-await-in-loop
      const response = await axios.post('https://api.paystack.co/refund', payload, { headers });

      if (response.data.status) {
         // eslint-disable-next-line no-await-in-loop
        await db.runTransaction(async (transaction) => {
          const refundRequestRef = refundRequestDoc.ref;
          const idempotencyDocRef = db.collection('idempotency_keys').doc(idempotencyKey);
          const eventDocRef = db.collection('new_eventTicketOrder').doc(refundData.eventId).collection('eventInvite').doc(refundData.userRequestId);
          const userDocRef = db.collection('new_userTicketOrder').doc(refundData.userRequestId).collection('eventInvite').doc(refundData.eventId);
          const userTicketIdRef = db.collection('new_ticketId').doc(refundData.userRequestId).collection('eventInvite').doc(refundData.eventId);
          const idempotencyDocSnapshot = await transaction.get(idempotencyDocRef);

          if (!idempotencyDocSnapshot.exists) {
            transaction.update(refundRequestRef, { status: 'processed' });
            transaction.update(eventDocRef, { refundRequestStatus: 'processed' });
            transaction.update(userDocRef, { refundRequestStatus: 'processed' });
            transaction.delete(userTicketIdRef);
            transaction.set(idempotencyDocRef, {
              refundResponse: response.data,
              created: admin.firestore.FieldValue.serverTimestamp()
            });
          } else {
            console.log(`Refund already processed for transaction ID: ${transactionId}`);
            return;
          }
        });
         // eslint-disable-next-line no-await-in-loop
        await alertAdminRefundSuccess(db, eventId, transactionId);
        console.log(`Refund processed for transaction ID: ${transactionId}`);
        return;
      } else {
        throw new Error('Refund failed with a non-success status');
      }
    } catch (error) {
      console.error(`Attempt ${retryCount + 1} for refund ${transactionId} failed:`, error);

      if (!isRetryableError(error)) {
         // eslint-disable-next-line no-await-in-loop
        await refundRequestDoc.ref.update({ status: 'error' });
         // eslint-disable-next-line no-await-in-loop
        await alertAdminRefundFailure(db, eventId, transactionId, error.message);
        throw error; // Non-retryable error, rethrow error
      }

      if (retryCount === maxRetries - 1) {
         // eslint-disable-next-line no-await-in-loop
        await alertAdminRefundFailure(db, eventId, transactionId, `Max retry attempts reached. Last error: ${error.message}`);
      }

      // Exponential backoff with a maximum delay cap
      delay = Math.min(delay * 2, MAX_DELAY);
      console.log(`Retryable error encountered for refund ${transactionId}. Retrying after ${delay}ms...`);
       // eslint-disable-next-line no-await-in-loop
      await new Promise(resolve => setTimeout(resolve, delay));
      retryCount++;
    }
  }

  if (retryCount >= maxRetries) {
     // eslint-disable-next-line no-await-in-loop
    await refundRequestDoc.ref.update({ status: 'failed' });
     // eslint-disable-next-line no-await-in-loop
    await alertAdminRefundFailure(db, eventId, transactionId, 'All retry attempts failed');
    throw new Error(`All retry attempts failed for refund ${transactionId}`);
  }
}

async function alertAdminRefundFailure(db, eventId, transactionId, errorMessage) {
  const failureDoc = {
    eventId: eventId,
    transactionId: transactionId,
    error: errorMessage,
    date: admin.firestore.FieldValue.serverTimestamp()
  };
   // eslint-disable-next-line no-await-in-loop
  await db.collection('refund_failures').add(failureDoc);
}

async function alertAdminRefundSuccess(db, eventId, transactionId) {
  const successDoc = {
    eventId: eventId,
    transactionId: transactionId,
    status: 'successful',
    date: admin.firestore.FieldValue.serverTimestamp()
  };
   // eslint-disable-next-line no-await-in-loop
  await db.collection('refund_success').add(successDoc);
}







// //event attending schedule reminder
// exports.dailyEventReminder = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
//   const today = new Date();
//   today.setHours(0, 0, 0, 0);
//   const sevenDaysFromNow = new Date();
//   sevenDaysFromNow.setDate(today.getDate() + 7);
//   sevenDaysFromNow.setHours(23, 59, 59, 999);

//   let processedAllEvents = false;
//   let lastEventDoc = null;

//   while (!processedAllEvents) {
//     let query =firestore.collection('new_allEvents')
//       .where('startDate', '>=', today)
//       .where('startDate', '<=', sevenDaysFromNow)
//       .orderBy('startDate')
//       .limit(BATCH_SIZE);

//     if (lastEventDoc) {
//       query = query.startAfter(lastEventDoc);
//     }
// // eslint-disable-next-line no-await-in-loop
//     const eventsSnapshot = await query.get();

//     if (eventsSnapshot.empty) {
//       processedAllEvents = true;
//       break;
//     }

//     for (const eventDoc of eventsSnapshot.docs) {
//       const event = eventDoc.data();

//       let processedAllInvites = false;
//       let lastInviteDoc = null;

//       while (!processedAllInvites) {
//         let invitesQuery = firestore.collection.collection('new_eventTicketOrder')
//           .doc(event.id)
//           .collection('eventInvite')
//           .limit(BATCH_SIZE);

//         if (lastInviteDoc) {
//           invitesQuery = invitesQuery.startAfter(lastInviteDoc);
//         }
// // eslint-disable-next-line no-await-in-loop
//         const invitesSnapshot = await invitesQuery.get();

//         if (invitesSnapshot.empty) {
//           processedAllInvites = true;
//           break;
//         }

//         for (const inviteDoc of invitesSnapshot.docs) {
//           const userId = inviteDoc.id;
//           const userRef = admin.firestore().doc(`user_general_settings/${userId}`);
//           const userDoc = await userRef.get();

          
//           const androidNotificationToken = userDoc.data().androidNotificationToken;

    

//           try {
//             // eslint-disable-next-line no-await-in-loop
//             if (androidNotificationToken) {
//               return sendNotification(androidNotificationToken, userId, userTicketNotificationMute  );
//               // await sendReminderNotification( androidNotificationToken,   userId, event);
//               // return sendNotification(androidNotificationToken, newMessage, userId, userTicketNotificationMute  );
//           } else {
//               console.log(`No notification token for user ${userId}`);
//           }

           
//           } catch (error) {
//             console.error(`Error sending reminder to user ${userId} for event ${event.title}:`, error);
//           }
//         }

//         lastInviteDoc = invitesSnapshot.docs[invitesSnapshot.docs.length - 1];
//       }
//     }

//     lastEventDoc = eventsSnapshot.docs[eventsSnapshot.docs.length - 1];
//   }

//   async function sendNotification(androidNotificationToken, userId, userTicketNotificationMute) {
//     const title = `Reminder`;
//     const body = 'This week event';

//     let message = {
//       notification: { body: body, title: title },
//       data: {
//           recipient: String(userId),
//           contentType: 'eventRoom',
//           contentId: String(newMessage.senderId),
//       },
//       token: androidNotificationToken
//   };

//   // If notifications are not muted, add the APNS payload with default sound
//   if (!userTicketNotificationMute) {
//       message.apns = {
//           payload: {
//               aps: {
//                   sound: 'default', // Or specify your custom notification sound file
//               },
//           },
//       };
//   }

//     try {
//         const response = await admin
//         .messaging()
//         .send(message);
//         console.log('message sent', response);
//     } catch (error) {
//         console.log('error sending message', error);
//         throw error;
//     }
// }
  
// });




















const BATCH_SIZE = 10; // Update this to your preferred batch size

// Event attending schedule reminder
exports.dailyEventReminder = functions.pubsub.schedule('every 12 hours').onRun(async (context) => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const sevenDaysFromNow = new Date();
  sevenDaysFromNow.setDate(today.getDate() + 7);
  sevenDaysFromNow.setHours(23, 59, 59, 999);

  let processedAllEvents = false;
  let lastEventDoc = null;

  while (!processedAllEvents) {
    let query = firestore.collection('new_allEvents')
      .where('startDate', '>=', today)
      .where('startDate', '<=', sevenDaysFromNow)
      .orderBy('startDate')
      .limit(BATCH_SIZE);

    if (lastEventDoc) {
      query = query.startAfter(lastEventDoc);
    }

  // eslint-disable-next-line no-await-in-loop
    const eventsSnapshot = await query.get(); // Corrected to use 'await'

    if (eventsSnapshot.empty) {
      processedAllEvents = true;
      break;
    }

    for (const eventDoc of eventsSnapshot.docs) {
      const event = eventDoc.data();
      let processedAllInvites = false;
      let lastInviteDoc = null;

      while (!processedAllInvites) {
        let invitesQuery = firestore.collection('new_eventTicketOrder')
          .doc(event.id)
          .collection('eventInvite')
          .limit(BATCH_SIZE);

        if (lastInviteDoc) {
          invitesQuery = invitesQuery.startAfter(lastInviteDoc);
        }
  // eslint-disable-next-line no-await-in-loop
        const invitesSnapshot = await invitesQuery.get(); // eslint-disable-next-line no-await-in-loop

        if (invitesSnapshot.empty) {
          processedAllInvites = true;
          break;
        }

        for (const inviteDoc of invitesSnapshot.docs) {
          const userId = inviteDoc.id;
          const userRef = firestore.doc(`user_general_settings/${userId}`);
            // eslint-disable-next-line no-await-in-loop
          const userDoc = await userRef.get(); // eslint-disable-next-line no-await-in-loop

          if (!userDoc.exists) {
            console.log(`User settings not found for user ${userId}`);
            continue;
          }

          const userData = userDoc.data();
          const androidNotificationToken = userData.androidNotificationToken;
          const userTicketNotificationMute = userData.userTicketNotificationMute || false;

          if (androidNotificationToken && !userTicketNotificationMute) {
            try {
                // eslint-disable-next-line no-await-in-loop
              await sendNotification(androidNotificationToken, userId, event); // eslint-disable-next-line no-await-in-loop
            } catch (error) {
              console.error(`Error sending reminder to user ${userId} for event ${event.title}:`, error);
            }
          } else {
            console.log(`No notification token for user ${userId} or notifications are muted.`);
          }
        }

        lastInviteDoc = invitesSnapshot.docs[invitesSnapshot.docs.length - 1];
      }
    }

    lastEventDoc = eventsSnapshot.docs[eventsSnapshot.docs.length - 1];
  }
});

async function sendNotification(androidNotificationToken, userId, event) {
  const title = `Reminder for event: ${event.title}`;
  const body = "Don't forget to attend your event this week!";

  let message = {
    notification: { title, body },
    data: {
      recipient: String(userId),
      contentType: 'eventReminder',
      contentId: String(event.id),
    },
    token: androidNotificationToken,
    apns: {
      payload: {
        aps: {
          sound: 'default',
        },
      },
    },
    android: {
      priority: 'high', // or "normal" (default)
    },
  };

  try {
      const response = await admin.messaging().send(message);
      console.log('Message sent', response);
  } catch (error) {
      console.log('Error sending message', error);
      throw error;
  }
}






















// exports.distributeEventFunds = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
//   const firestore.collection = admin.firestore();
//   const eventsSnapshot = await db.collection('new_allEvents')
//     .where('closingDay', '<=', admin.firestore.Timestamp.now())
//     .where('fundsDistributed', '==', false)
//     .get();

//   let batch = db.batch();
//   let operationCount = 0;
//   const batches = [batch]; // An array to keep track of all batches

//   for (const eventDoc of eventsSnapshot.docs) {
//     const eventId = eventDoc.id;
//     const idempotencyKey = `transfer_${eventId}_${new Date().toISOString().split('T')[0]}`;

//     const idempotencyDoc = await db.collection('idempotency_keys').doc(idempotencyKey).get();
//     if (idempotencyDoc.exists) {
//       console.log(`Transfer for event ${eventId} has already been made.`);
//       continue;
//     }

//     if (operationCount >= 500) {
//       // Start a new batch
//       batch = db.batch();
//       batches.push(batch);
//       operationCount = 0;
//     }

//     try {
//       const organizerShare = await calculateOrganizerShare(eventDoc.data());
//       const response = await paystack.subaccount.createTransfer({
//         source: "balance",
//         amount: organizerShare,
//         recipient: eventData.subaccountId,
//       });

//       if (response.status) {
//         batch.update(eventDoc.ref, { fundsDistributed: true });
//         batch.set(db.collection('idempotency_keys').doc(idempotencyKey), {
//           created: admin.firestore.FieldValue.serverTimestamp()
//         });
//         operationCount += 2; // Update and Set are two operations
//       } else {
//         throw new Error('Transfer failed');
//       }
//     } catch (error) {
//       console.error('Error when attempting to distribute funds:', error);
//     }
//   }

//   // Commit all batches
//   const commitPromises = batches.map(b => b.commit());
//   await Promise.all(commitPromises);

//   console.log('All batches committed successfully.');
// });






// exports.createSubaccount = functions.https.onCall(async (data, context) => {
//   // Check if the user is authenticated
//   if (!context.auth) {
//     throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
//   }

//   const PAYSTACK_SECRET_KEY = functions.config().paystack.secret_key; // Assuming you've set this in your environment config

//   // Verify the bank account first
//   try {
//     const verificationResponse = await axios.get(`https://api.paystack.co/bank/resolve?account_number=${data.account_number}&bank_code=${data.bank_code}`, {
//       headers: {
//         Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
//       },
//     });

//     // Check if verification was successful
//     if (!verificationResponse.data.status) {
//       throw new functions.https.HttpsError('aborted', 'Bank account verification failed.');
//     }

//     // Bank account is verified, proceed with creating the subaccount
//     const paystackResponse = await axios.post('https://api.paystack.co/subaccount', {
//       business_name: data.business_name, 
//       settlement_bank: data.bank_code,   
//       account_number: data.account_number, 
//       percentage_charge: data.percentage_charge 
//     }, {
//       headers: {
//         Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
//         'Content-Type': 'application/json'
//       }
//     });

//     if (paystackResponse.data.status) {
//       // Subaccount created successfully
//       return { subaccount_id: paystackResponse.data.data.subaccount_code};
//     } else {
//       // Failed to create subaccount
//       throw new functions.https.HttpsError('unknown', 'Failed to create subaccount with Paystack');
//     }
//   } catch (error) {
//     console.error('Detailed error:', {
//       message: error.message,
//       stack: error.stack,
//       response: error.response ? error.response.data : null,
//     });
//     throw new functions.https.HttpsError(
//       'unknown',
//       'Error creating subaccount',
//       error.response ? error.response.data : error.message
//     );
//   }
// });




// exports.deleteEmptyVideoUsers = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
//   // Wait for 2 minutes
//   await new Promise(resolve => setTimeout(resolve, 2 * 60 * 1000));

//   // Loop through each user
//   users.forEach(async (userDoc) => {
//     const user = userDoc.data();

//     // Check if professionalVideo1 field is empty
//     if (!user.professionalVideo1) {
//       const userId = userDoc.id;

//       const collections = [
//         { collection: 'forums', subCollection: 'userForums' },
//         { collection: 'posts', subCollection: 'userPosts' },
//         { collection: 'new_events', subCollection: 'userEvents' },
//         { collection: 'following', subCollection: 'userFollowing' },
//         { collection: 'followers', subCollection: 'userFollowers' },
//         { collection: 'users', subCollection: 'chats' },
//       ];
      
//       // Delete Firestore data
//       const deletions = collections.map(async (collection) => {
//         try {
//           const docs = await firestore.collection(collection.collection).doc(userId).collection(collection.subCollection).listDocuments();
//           docs.forEach((doc) => doc.delete());
//         } catch (error) {
//           console.error(`Failed to delete Firestore data for user ${userId} in collection ${collection.collection}/${collection.subCollection}: `, error);
//         }
//       });
      
//       // Delete Storage data
//       const storagePaths = [
//         `images/events/${userId}`,
//         `images/messageImage/${userId}`,
//         `images/users/${userId}`,
//         `images/professionalPicture1/${userId}`,
//         `images/professionalPicture2/${userId}`,
//         `images/professionalPicture3/${userId}`,
//         `images/validate/${userId}`,
//       ];
      
//       storagePaths.forEach(async (path) => {
//         try {
//           const files = await storage.bucket().getFiles({ prefix: path });
//           files[0].forEach((file) => {
//             file.delete();
//           });
//         } catch (error) {
//           console.error(`Failed to delete Storage data for user ${userId} in path ${path}: `, error);
//         }
//       });

//       // Delete user document
//       try {
//         await firestore.collection('users').doc(userId).delete();
//         await firestore.collection('usersAuthors').doc(userId).delete();
//       } catch (error) {
//         console.error(`Failed to delete user document for user ${userId}: `, error);
//       }
//   // Remove user from follow lists
//   await removeUserFromFollowLists(userId);

//       // Delete user from Authentication
//       try {
//         await admin.auth().deleteUser(userId);
//       } catch (error) {
//         console.error(`Failed to delete user from Authentication for user ${userId}: `, error);
//       }

//       // Wait for all deletions to finish
//       await Promise.all(deletions);
//     }
//   });
// });


async function removeUserFromFollowLists(userId) {
  // Get all users
  const usersSnapshot = await firestore.collection('users').get();

  // Loop through each user
  usersSnapshot.forEach(async (userDoc) => {
    const otherUserId = userDoc.id;
    const otherUser = userDoc.data();

    // Check if this user is following the target user or is followed by the target user
    const isFollowing = otherUser.following.includes(userId);
    const isFollowed = otherUser.followers.includes(userId);

    if (isFollowing || isFollowed) {
      // Start a batch
      let batch = firestore.batch();

      if (isFollowing) {
        // Remove the target user from the 'following' array
        batch.update(userDoc.ref, {
          following: admin.firestore.FieldValue.arrayRemove(userId)
        });
      }

      if (isFollowed) {
        // Remove the target user from the 'followers' array
        batch.update(userDoc.ref, {
          followers: admin.firestore.FieldValue.arrayRemove(userId)
        });
      }

      // Commit the batch
      await batch.commit();
    }
  });
}


async function removeUserFromBlockedList(userId) {
  // Get all users
  const usersSnapshot = await firestore.collection('users').get();

  // Loop through each user
  usersSnapshot.forEach(async (userDoc) => {
    const otherUserId = userDoc.id;
    const otherUser = userDoc.data();

    // Check if this user is blocking the target user or is followed by the target user
    const isBlocking = otherUser.usersBlocking.includes(userId);
    const isBlocked = otherUser.usersBlocked.includes(userId);

    if (isBlocking || isBlocked) {
      // Start a batch
      let batch = firestore.batch();

      if (isBlocking) {
        // Remove the target user from the 'usersBlocking' array
        batch.update(userDoc.ref, {
          usersBlocking: admin.firestore.FieldValue.arrayRemove(userId)
        });
      }

      if (isBlocked) {
        // Remove the target user from the 'usersBlocked' array
        batch.update(userDoc.ref, {
          usersBlocked: admin.firestore.FieldValue.arrayRemove(userId)
        });
      }

      // Commit the batch
      await batch.commit();
    }
  });
}





exports.deleteUserData = functions.auth.user().onDelete(async (user) => {
  const userId = user.uid;

  const collections = [
    { collection: 'posts', subCollection: 'userPosts' },
    { collection: 'new_events', subCollection: 'userEvents' },
    { collection: 'following', subCollection: 'userFollowing' },
    { collection: 'followers', subCollection: 'userFollowers' },
    { collection: 'users', subCollection: 'chats' },
    { collection: 'usersBlocked', subCollection: 'userBlocked' },
    { collection: 'usersBlocking', subCollection: 'userBlocking' },

  ];
  
  // Delete Firestore data
  const deletions = collections.map(async (collection) => {
    const docs = await firestore.collection(collection.collection).doc(userId).collection(collection.subCollection).listDocuments();
    docs.forEach((doc) => doc.delete());
  });
  
  // Delete Storage data
  const storagePaths = [
    `images/events/${userId}`,
    `images/posts/${userId}`,
    `images/messageImage/${userId}`,
    `images/users/${userId}`,
    `images/professionalPicture1/${userId}`,
    `images/professionalPicture2/${userId}`,
    `images/professionalPicture3/${userId}`,
    `images/validate/${userId}`,
  ];
  
  storagePaths.forEach(async (path) => {
    const files = await storage.bucket().getFiles({ prefix: path });
    files[0].forEach((file) => {
      file.delete();
    });
  });

  // Remove user from follow lists
  await removeUserFromFollowLists(userId);

  // Remove user from block lists
  await removeUserFromBlockedList(userId);

  // Delete user document
  firestore.collection('users').doc(userId).delete();
  firestore.collection('usersAuthors').doc(userId).delete();

  // Wait for all deletions to finish
  await Promise.all(deletions);
});








exports.onFollowUser = functions.firestore
  .document('/new_followers/{userId}/userFollowers/{followerId}')
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // post+Feed/
    const followedUserPostsRef = admin
      .firestore()
      .collection('new_posts')
      .doc(userId)
      .collection('userPosts');
    const userFeedRef = admin
      .firestore()
      .collection('new_postFeeds')
      .doc(followerId)
      .collection('userFeed');
    const followedUserPostsSnapshot = await followedUserPostsRef.get();
    followedUserPostsSnapshot.forEach(doc => {
      if (doc.exists) {
        userFeedRef.doc(doc.id).set(doc.data());
      }
    });

  //   // forum+ForumFeed
  //   const followedUserForumsRef = admin
  //   .firestore()
  //   .collection('forums')
  //   .doc(userId)
  //   .collection('userForums');
  // const userForumFeedRef = admin
  //   .firestore()
  //   .collection('forumFeeds')
  //   .doc(followerId)
  //   .collection('userForumFeed');
  // const followedUserForumsSnapshot = await followedUserForumsRef.get();
  // followedUserForumsSnapshot.forEach(doc => {
  //   if (doc.exists) {
  //     userForumFeedRef.doc(doc.id).set(doc.data());
  //   }
  // });

   // event+EventFeed
   const followedUserEventsRef = admin
   .firestore()
   .collection('new_events')
   .doc(userId)
   .collection('userEvents');
 const userEventFeedRef = admin
   .firestore()
   .collection('new_eventFeeds')
   .doc(followerId)
   .collection('userEventFeed');
 const followedUserEventsSnapshot = await followedUserEventsRef.get();
 followedUserEventsSnapshot.forEach(doc => {
   if (doc.exists) {
     userEventFeedRef.doc(doc.id).set(doc.data());
   }
 });


  });




exports.onUnfollowUser = functions.firestore
  .document('/new_followers/{userId}/userFollowers/{followerId}')
  .onDelete(async (snapshot, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // post+feed 
    const userFeedRef = admin
      .firestore()
      .collection('new_postFeeds')
      .doc(followerId)
      .collection('userFeed')
      .where('authorId', '==', userId);
    const userPostsSnapshot = await userFeedRef.get();
    userPostsSnapshot.forEach(doc => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });

  //  

  // event+feed 
  const userEventFeedRef = admin
  .firestore()
  .collection('new_eventFeeds')
  .doc(followerId)
  .collection('userEventFeed')
  .where('authorId', '==', userId);
const userEventsSnapshot = await userEventFeedRef.get();
userEventsSnapshot.forEach(doc => {
  if (doc.exists) {
    doc.ref.delete();
  }
});

    
  });

// exports.onUploadPost = functions.firestore
//   .document('/posts/{userId}/userPosts/{postId}')
//   .onCreate(async (snapshot, context) => {
//     console.log(snapshot.data());
//     const userId = context.params.userId;
//     const postId = context.params.postId;
//     const userFollowersRef = admin
//       .firestore()
//       .collection('followers')
//       .doc(userId)
//       .collection('userFollowers');
//     const userFollowersSnapshot = await userFollowersRef.get();
//     userFollowersSnapshot.forEach(doc => {
//       admin
//         .firestore()
//         .collection('feeds')
//         .doc(doc.id)
//         .collection('userFeed')
//         .doc(postId)
//         .set(snapshot.data());
//     });
//     // admin.firestore().collection('allPosts')
//     // .doc(postId)
//     // .set(snapshot.data());
//   });


 

//   exports.onDeleteFeedPost = functions.firestore
//   .document('/posts/{userId}/userPosts/{postId}')
// .onDelete(async (snapshot, context) => {
//   const userId = context.params.userId;
//   const postId = context.params.postId;
//   console.log(snapshot.data());
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(async userDoc => {
//     const postRef = admin
//       .firestore()
//       .collection('feeds')
//       .doc(userDoc.id)
//       .collection('userFeed');
//     const postDoc = await postRef.doc(postId).get();
//     if (postDoc.exists) {
//       postDoc.ref.delete();
//     }
//   })
//   admin.firestore().collection('allPosts')
//   .doc(postId).delete();
// });


  
// exports.onUploadForum = functions.firestore
// .document('/forums/{userId}/userForums/{forumId}')
// .onCreate(async (snapshot, context) => {
//   console.log(snapshot.data());
//   const userId = context.params.userId;
//   const forumId = context.params.forumId;
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(doc => {
//     admin
//       .firestore()
//       .collection('forumFeeds')
//       .doc(doc.id)
//       .collection('userForumFeed')
//       .doc(forumId)
//       .set(snapshot.data());
//   });

// });


//   exports.onDeleteFeedForums = functions.firestore
//   .document('/forums/{userId}/userForums/{forumId}')
// .onDelete(async (snapshot, context) => {
//   const userId = context.params.userId;
//   const forumId = context.params.forumId;
//   console.log(snapshot.data());
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(async userDoc => {
//     const forumRef = admin
//       .firestore()
//       .collection('forumFeeds')
//       .doc(userDoc.id)
//       .collection('userForumFeed')
//     const forumDoc = await forumRef.doc(forumId).get();
//     if (forumDoc.exists) {
//       forumDoc.ref.delete();
//     }
//   })
//   admin.firestore().collection('allForums')
//   .doc(forumId).delete();
// });


// exports.onDeleteFeedThought = functions.firestore
// .document('/thoughts/{forumId}/forumThoughts/{thoughtId}')
// .onDelete(async (snapshot, context) => {
// const forumId = context.params.forumId;
// const thoughtId = context.params.thoughtId;
// console.log(snapshot.data());
// const thoghtsRef =  admin
//     .firestore()
//     .collection('replyThoughts')
//     .doc(thoughtId)
//     .collection('replyThoughts')
//     const thoghtsSnapshot = await thoghtsRef.get();
//     thoghtsSnapshot.forEach(async userDoc => {    
//       if (userDoc.exists) {
//         userDoc.ref.delete();
//       }
//     })
  

// });

exports.onUploadEvent = functions.firestore
  .document('/new_events/{userId}/userEvents/{eventId}')
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const eventId = context.params.eventId;
    const userFollowersRef = admin
      .firestore()
      .collection('new_followers')
      .doc(userId)
      .collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();

    const batch = admin.firestore().batch();

    userFollowersSnapshot.forEach((doc) => {
      const followerId = doc.id;
      const eventFeedRef = admin
        .firestore()
        .collection('new_eventFeeds')
        .doc(followerId)
        .collection('userEventFeed')
        .doc(eventId);
      batch.set(eventFeedRef, snapshot.data());
    });

    // Commit the batch operation to update all follower documents
    return batch.commit();
  });

exports.onDeleteFeedEvent = functions.firestore
  .document('/new_events/{userId}/userEvents/{eventId}')
  .onDelete(async (snapshot, context) => {
    const userId = context.params.userId;
    const eventId = context.params.eventId;
    console.log(snapshot.data());
    const userFollowersRef = admin
      .firestore()
      .collection('new_followers')
      .doc(userId)
      .collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();

    const batch = admin.firestore().batch();

    userFollowersSnapshot.forEach((doc) => {
      const followerId = doc.id;
      const eventFeedRef = admin
        .firestore()
        .collection('new_eventFeeds')
        .doc(followerId)
        .collection('userEventFeed')
        .doc(eventId);
      batch.delete(eventFeedRef);
    });


    
    // Commit the batch operation to delete all follower documents
    await batch.commit();

    // Delete the event from the 'allEvents' collection
    return admin.firestore().collection('allEvents').doc(eventId).delete();
  });


  exports.onUpdateEvent = functions.firestore
  .document('/new_events/{userId}/userEvents/{eventId}')
  .onUpdate(async (snapshot, context) => {
    const userId = context.params.userId;
    const eventId = context.params.eventId;
    const newEventData = snapshot.after.data();
    console.log(newEventData);

    const userFollowersRef = admin
      .firestore()
      .collection('new_followers')
      .doc(userId)
      .collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();

    const batch = admin.firestore().batch();

    userFollowersSnapshot.forEach((userDoc) => {
      const followerId = userDoc.id;
      const eventRef = admin
        .firestore()
        .collection('new_eventFeeds')
        .doc(followerId)
        .collection('userEventFeed')
        .doc(eventId);
      batch.update(eventRef, newEventData);
    });

    // Commit the batch operation to update all follower documents
    await batch.commit();

    const allEventRef = admin.firestore().collection('new_allEvents').doc(eventId);
    batch.update(allEventRef, newEventData);

    // Commit the batch operation to update the event in 'new_allEvents' collection
    await batch.commit();
  });
  
// exports.onUploadEvent = functions.firestore
// .document('/events/{userId}/userEvents/{eventId}')
// .onCreate(async (snapshot, context) => {
//   console.log(snapshot.data());
//   const userId = context.params.userId;
//   const eventId = context.params.eventId;
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(doc => {
//     admin
//       .firestore()
//       .collection('new_eventFeeds')
//       .doc(doc.id)
//       .collection('userEventFeed')
//       .doc(eventId)
//       .set(snapshot.data());
//   });
 
// });

//   exports.onDeleteFeedEvent = functions.firestore
//   .document('/events/{userId}/userEvents/{eventId}')
// .onDelete(async (snapshot, context) => {
//   const userId = context.params.userId;
//   const eventId = context.params.eventId;
//   console.log(snapshot.data());
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(async userDoc => {
//     const eventRef = admin
//       .firestore()
//       .collection('new_eventFeeds')
//       .doc(userDoc.id)
//       .collection('userEventFeed')
//     const eventDoc = await eventRef.doc(eventId).get();
//     if (eventDoc.exists) {
//       eventDoc.ref.delete();
//     }
//   })
//   admin.firestore().collection('allEvents')
//   .doc(eventId).delete();
  
// });

// exports.onUpdatePost = functions.firestore
// .document('/posts/{userId}/userPosts/{postId}')
// .onUpdate(async (snapshot, context) => {
//   const userId = context.params.userId;
//   const postId = context.params.postId;
//   const newPostData = snapshot.after.data();
//   console.log(newPostData);
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(async userDoc => {
//     const postRef = admin
//       .firestore()
//       .collection('feeds')
//       .doc(userDoc.id)
//       .collection('userFeed');
//     const postDoc = await postRef.doc(postId).get();
//     if (postDoc.exists) {
//       postDoc.ref.update(newPostData);
//     }
//   })

//   const allPostsRef = admin
//   .firestore()
//   .collection('allPosts')
//   const postDoc = await allPostsRef.doc(postId).get();
//   if (postDoc.exists) {
//     postDoc.ref.update(newPostData);
//   }
// });



// exports.onUpdateForum = functions.firestore
// .document('/forums/{userId}/userForums/{forumId}')
// .onUpdate(async (snapshot, context) => {
//   const userId = context.params.userId;
//   const forumId = context.params.forumId;
//   const newForumData = snapshot.after.data();
//   console.log(newForumData);
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(async userDoc => {
//     const forumRef = admin
//       .firestore()
//       .collection('forumFeeds')
//       .doc(userDoc.id)
//       .collection('userForumFeed');
//     const forumDoc = await forumRef.doc(forumId).get();
//     if (forumDoc.exists) {
//       forumDoc.ref.update(newForumData);
//     }
//   })

//   const allForumsRef = admin
//   .firestore()
//   .collection('allForums')
//   const forumDoc = await allForumsRef.doc(forumId).get();
//   if (forumDoc.exists) {
//     forumDoc.ref.update(newForumData);
//   }
// });

// exports.onUpdateEvent = functions.firestore
// .document('/events/{userId}/userEvents/{eventId}')
// .onUpdate(async (snapshot, context) => {
//   const userId = context.params.userId;
//   const eventId = context.params.eventId;
//   const newEventData = snapshot.after.data();
//   console.log(newEventData);
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(async userDoc => {
//     const eventRef = admin
//       .firestore()
//       .collection('new_eventFeeds')
//       .doc(userDoc.id)
//       .collection('userEventFeed');
//     const eventDoc = await eventRef.doc(eventId).get();
//     if (eventDoc.exists) {
//       eventDoc.ref.update(newEventData);
//     }
//   })
//  const allEventRef = admin
//   .firestore()
//   .collection('new_allEvents')
//   const eventDoc = await allEventRef.doc(eventId).get();
//   if (eventDoc.exists) {
//     eventDoc.ref.update(newEventData);
//   }
  
// });


// exports.sendEventInLocationNotifications = 

// functions.pubsub.schedule('every day 11:17').timeZone('GMT').onRun(async (context) => {
//   // Fetch this week's events
//   const now = admin.firestore.Timestamp.now();
//   const oneWeekFromNow = admin.firestore.Timestamp.fromMillis(now.toMillis() + 7 * 24 * 60 * 60 * 1000);
//   const eventsSnapshot = await firestore.collection('new_allEvents').where('startDate', '>=', now).where('startDate', '<=', oneWeekFromNow).get();
//   const events = eventsSnapshot.docs.map(doc => doc.data());

//   async function sendNotification(androidNotificationToken, event, user) {
//     const message = {
//       notification: {
//         body: `New event at ${event.city}`,
//         title: event.title
//       },
//       token: androidNotificationToken,
//       data: {recipient: user.id},
//     };

//     return admin
//       .messaging()
//       .send(message)
//       .then(response => {
//         console.log('message sent', response);
//         return response;
//       }).catch(error =>{
//         console.log('error sending message', error);
//         throw error;
//       });
//   }

//   const eventPromises = events.map(async (event) => {
//     // Querying for users subscribed to the city of the event
//     const userFollowersRef = admin
//       .firestore()
//       .collection('user_location_settings')
//       .where('city', '==', event.city); // changed from events.city to event.city

//     const usersSnapshot = await userFollowersRef.get();
//     const users = usersSnapshot.docs.map(doc => doc.data());

//     // Send notifications to users
//     const userPromises = users.map((user) => {
//       const androidNotificationToken = user.androidNotificationToken; // get the token from the user object

//       if (androidNotificationToken) {
//         return sendNotification(androidNotificationToken, event, user);
//       } else {
//         console.log(`No notification token for user: ${user.id}`); // Log the user ID for which token is not available
//         return null;
//       }
//     });

//     return Promise.all(userPromises);
//   });

//   await Promise.all(eventPromises);
// });


exports.onCreateNewActivity = functions.firestore
.document('/new_activities/{userId}/userActivities/{userActivitiesId}')
.onCreate(async (snapshot, context) => {
  console.log('activity notification created', snapshot.data());
  const userId = context.params.userId;
  const createdActivityItem = snapshot.data();
  const usersRef = admin.firestore().doc(`user_general_settings/${userId}`);
  const doc = await usersRef.get();
  const androidNotificationToken = doc.data().androidNotificationToken;
  let title;
  let body;

  if(androidNotificationToken){
    sendNotification(androidNotificationToken, createdActivityItem)
  } else {
    console.log('no notification token');
  }

   async function sendNotification(androidNotificationToken, createdActivityItem) {
    switch (createdActivityItem.type){
      case 'newEventInNearYou':
        title = createdActivityItem.authorName;
        break;
      case 'inviteRecieved':
        title = createdActivityItem.authorName;
        break;
        case 'eventUpdate':
        title = createdActivityItem.authorName;
        break;
      case 'ticketPurchased':
        title = createdActivityItem.authorName;
        break;
      case 'refundRequested':
        title = createdActivityItem.authorName;
        break;
      case 'follow':
        title = createdActivityItem.authorName;
        break;
       
      default: 
        title = `${createdActivityItem.authorName}  [ ${createdActivityItem.type} ]`
    }
    body  = createdActivityItem.comment;


    const message = {notification: {body: body, title: title},
      data: {
        recipient: userId,
        contentType: createdActivityItem.type,
        contentId: createdActivityItem.postId,
        // title: title,
        // body: body,
      },
      token: androidNotificationToken,
      apns: {
        payload: {
          aps: {
            sound: 'default',
          },
        },
      },
    };
    
    // const message = {
    //   notification: {body: body, title: title},
    //   token: androidNotificationToken,
    //   data: {recipient: userId,   contentType: createdActivityItem.type,    contentId: createdActivityItem.postId,   },
    // };

    try {
       const response = await admin
         .messaging()
         .send(message);
       console.log('message sent', response);
     } catch (error) {
       console.log('error sending message', error);
       throw error;
     }
  }
});





// exports.onCreateActivityNotification = functions.firestore
// .document('/activities/{userId}/userActivities/{userActivitiesId}')
// .onCreate(async (snapshot, context) => {
//   console.log('activity notification created', snapshot.data());
//   const userId = context.params.userId;
//   const userActivitiesId = context.params.userActivitiesId;
//   const createdActivityItem = snapshot.data();
//   const usersRef = admin.firestore().doc(`users/${userId}`);
//   const doc = await usersRef.get();
//   const androidNotificationToken = doc.data().androidNotificationToken;
 
//   if(androidNotificationToken){
//    sendNotification(androidNotificationToken, createdActivityItem )
//   } else {
//     console.log('no notification token');
//   }
//   function sendNotification(androidNotificationToken, userActivities)
//  {
//    let body;
  //  switch (userActivities.comment){
  //   case null:
  //     body = `[ ${userActivities.authorName} ] Dope`
  //     break;
     
  //     default: body = `[ ${userActivities.authorName} ] ${userActivities.comment} `
  //  }
//    let title;
//    switch (userActivities.comment){
//     case null:
//       title = `New reaction`
//       break;
     
//       default: title = `New punch vibe `
//    }
//    const message = {
//     notification: {body: body, title: title},
//     token: androidNotificationToken,
//     data: {recipient: userId},
//    };
//     admin
//    .messaging()
//    .send(message)
//    .then(response => {
//      return console.log('message sent', response);
//    }).catch(error =>{
//     console.log('error sending message', error);
//    })
//  }

// });



// exports.onCreateActivityEventNotification = functions.firestore
// .document('/activitiesEvent/{userId}/userActivitiesEvent/{userActivitiesEventId}')
// .onCreate(async (snapshot, context) => {
//   console.log('activity notification created', snapshot.data());
//   const userId = context.params.userId;
//   const userActivitiesEventId = context.params.userActivitiesEventId;
//   const createdActivityItem = snapshot.data();
//   const usersRef = admin.firestore().doc(`users/${userId}`);
//   const doc = await usersRef.get();
//   const androidNotificationToken = doc.data().androidNotificationToken;
 
//   if(androidNotificationToken){
//    sendNotification(androidNotificationToken, createdActivityItem )
//   } else {
//     console.log('no notification token');
//   }
//   function sendNotification(androidNotificationToken, userActivitiesEvent)
//  {

//     let body;
//     switch (userActivitiesEvent.invited){
//      case true:
//        body = ` ${userActivitiesEvent.eventInviteType} `
//        break;
      
//        default: body = `[ ${userActivitiesEvent.authorName} ] ${userActivitiesEvent.ask} `
//     }
//     let title;
//     switch (userActivitiesEvent.invited){
//      case true:
//        title = `New event invitation`
//        break;
      
//        default: title =  `New event question  `
//     }
  
//    const message = {
//     notification: {body: body, title: title},
//     token: androidNotificationToken,
//     data: {recipient: userId},
//    };
//     admin
//    .messaging()
//    .send(message)
//    .then(response => {
//      return console.log('message sent', response);
//    }).catch(error =>{
//     console.log('error sending message', error);
//    })
//  }

// });




// exports.onCreateNewMessageActivity = functions.firestore
// .document('/messages/{messageId}/conversation/{conversationId}')
// .onCreate(async (snapshot, context) => {
//   console.log('activity notification created', snapshot.data());
//   const createdActivityItem = snapshot.data();
//     const userId = createdActivityItem.receiverId;

//   const usersRef = admin.firestore().doc(`user_general_settings/${userId}`);
//   const usersSendersRef = admin.firestore().doc(`user_author/${createdActivityItem.senderId}`);
//   const sender = await usersSendersRef.get();

//   const userCollectionRef = admin.firestore().collection(`user_author/${createdActivityItem.receiverId}/new_chats/${createdActivityItem.senderId}`);
//   const userNotification = await userCollectionRef.get();
//   const userNotificationMute = await userNotification.data().muteMessage;

//   const doc = await usersRef.get();
//   const androidNotificationToken = doc.data().androidNotificationToken;
//   let title;
//   let body;

//   if(androidNotificationToken){
//     sendNotification(androidNotificationToken, createdActivityItem,  userNotificationMute)
//   } else {
//     console.log('no notification token');
//   }

//    async function sendNotification(androidNotificationToken, createdActivityItem,  userNotificationMute) {
  
//     title  =  `${sender.data().userName}  [ Message ]`;
//     body  = createdActivityItem.content;


//     let message = {
//       notification: { body: body, title: title },
//       data: {
//           recipient: userId,
//           contentType: 'message',
//           contentId: createdActivityItem.senderId,
//       },
//       token: androidNotificationToken
//   };

//   // If notifications are not muted, add the APNS payload with default sound
//   if (!userNotificationMute) {
//       message.apns = {
//           payload: {
//               aps: {
//                   sound: 'default', // Or specify your custom notification sound file
//               },
//           },
//       };
//   }

//     // const message = {notification: {body: body, title: title},
//     //   data: {
//     //     recipient: userId,
//     //     contentType: 'message',
//     //     contentId: createdActivityItem.senderId,
     
//     //   },
//     //   token: androidNotificationToken,
//     //   apns: {
//     //     payload: {
//     //       aps: {
//     //         sound: 'default',
//     //       },
//     //     },
//     //   },
//     // };
    
//     try {
//        const response = await admin
//          .messaging()
//          .send(message);
//        console.log('message sent', response);
//      } catch (error) {
//        console.log('error sending message', error);
//        throw error;
//      }
//   }
// });


exports.onNewEventRoomMessage = functions.firestore
.document('/new_eventChatRoomsConversation/{eventId}/roomChats/{chatId}')
.onCreate(async (snapshot, context) => {
    console.log('New chat message created', snapshot.data());
    const newMessage = snapshot.data();
    const eventId = context.params.eventId;
    const usersSendersRef = admin.firestore().doc(`user_author/${newMessage.senderId}`);
    const sender = await usersSendersRef.get();

    const chatRoomUsersCollectionRef = admin.firestore().collection(`new_eventTicketOrder/${eventId}/eventInvite`);
    const chatRoomUsersSnapshot = await chatRoomUsersCollectionRef.get();

    if (chatRoomUsersSnapshot.empty) {
        console.log('No users found for this ticket');
        return;
    }

    const notifications = chatRoomUsersSnapshot.docs.map(async doc => {
        const userId = doc.id;
        if (userId === newMessage.senderId) {
            return; // Skip the sender
        }
        const userRef = admin.firestore().doc(`user_general_settings/${userId}`);
        const userDoc = await userRef.get();


        const userTiketIdRef = admin.firestore().doc(`new_ticketId/${userId}/eventInvite/${eventId}`);
        const userTicketIdDoc = await userTiketIdRef.get();
        const userTicketNotificationMute = userTicketIdDoc.data().muteNotification;

        const androidNotificationToken = userDoc.data().androidNotificationToken;

        if (androidNotificationToken) {
            return sendNotification(androidNotificationToken, newMessage, userId, userTicketNotificationMute  );
        } else {
            console.log(`No notification token for user ${userId}`);
        }
    });

    return Promise.all(notifications);

    async function sendNotification(androidNotificationToken, newMessage, userId, userTicketNotificationMute) {
        const title = `${sender.data().userName} [ Event room ]`;
        const body = newMessage.content;

        let message = {
          notification: { body: body, title: title },
          data: {
              recipient: String(userId),
              contentType: 'eventRoom',
              contentId: String(newMessage.senderId),
          },
          token: androidNotificationToken
      };
  
      // If notifications are not muted, add the APNS payload with default sound
      if (!userTicketNotificationMute) {
          message.apns = {
              payload: {
                  aps: {
                      sound: 'default', // Or specify your custom notification sound file
                  },
              },
          };
      }

        // const message = {
        //     notification: {body: body, title: title},
        //     data: {
        //         recipient: String(userId),
        //         contentType: 'eventRoom',
        //         contentId: String(newMessage.senderId),
        //     },
        //     token: androidNotificationToken,
        //     apns: {
        //         payload: {
        //             aps: {
        //                 sound:userTicketNotificationMute == true? 'default' : '',
        //             },
        //         },
        //     },
        // };

        try {
            const response = await admin
            .messaging()
            .send(message);
            console.log('message sent', response);
        } catch (error) {
            console.log('error sending message', error);
            throw error;
        }
    }
});



// exports.onNewEventRoomMessage = functions.firestore
// .document('/new_eventChatRoomsConversation/{ticketId}/roomChats/{chatId}')
// .onCreate(async (snapshot, context) => {
//   console.log('New chat message created', snapshot.data());
//   const newMessage = snapshot.data();
//   const ticketId = context.params.ticketId;
//   const usersSendersRef = admin.firestore().doc(`user_author/${newMessage.senderId}`);
//   const sender = await usersSendersRef.get();


//   const chatRoomUsersCollectionRef = admin.firestore().collection(`new_eventTicketOrder/${ticketId}/eventInvite`);
// const chatRoomUsersSnapshot = await chatRoomUsersCollectionRef.get();

// if (chatRoomUsersSnapshot.empty) {
//   console.log('No users found for this ticket');
//   return;
// }

// chatRoomUsersSnapshot.forEach(async doc => {
//   const userId = doc.id; // assuming the document ID is the user ID
//   const userRef = admin.firestore().doc(`user_general_settings/${userId}`);
//   const userDoc = await userRef.get();
//   const androidNotificationToken = userDoc.data().androidNotificationToken;

//   if (androidNotificationToken) {
//     await sendNotification(androidNotificationToken, newMessage, userId);
//   } else {
//     console.log(`No notification token for user ${userId}`);
//   }
// });

//   async function sendNotification(androidNotificationToken, newMessage, userId) {
//     const title = `${sender.data().userName} [ Event room ]`;
//     const body = newMessage.content;

//     const message = {
//       notification: {body: body, title: title},
//       data: {
//         recipient: String(userId),
//         contentType: 'eventRoom',
//         contentId: String(newMessage.senderId),
//       },
//       token: androidNotificationToken,
//       apns: {
//         payload: {
//           aps: {
//             sound: 'default',
//           },
//         },
//       },
//     };

//     try {
//       const response = await admin
//         .messaging()
//         .send(message);
//       console.log('message sent', response);
//     } catch (error) {
//       console.log('error sending message', error);
//       throw error;
//     }
//   }
// });



// exports.onCreateChatMessage = functions.firestore
// .document('/messages/{messageId}/conversation/{conversationId}')
// .onCreate(async (snapshot, context) => {
//   console.log('activity notification created', snapshot.data());
//   const userId = context.params.userId;
//   const chatActivitiesId = context.params.chatActivitiesId;
//   const createdActivityItem = snapshot.data();
//   const usersRef = admin.firestore().doc(`users/${userId}`);
//   const doc = await usersRef.get();
//   const androidNotificationToken = doc.data().androidNotificationToken;
 
//   if(androidNotificationToken){
//    sendNotification(androidNotificationToken, createdActivityItem )
//   } else {
//     console.log('no notification token');
//   }
//   function sendNotification(androidNotificationToken, chatActivities)
//  {

//     let body;
//     switch (chatActivities.liked){
//      case true:
//        body = `[ ${chatActivities.authorName}] like ${chatActivities.comment} `
//        break;
      
//        default: body = `[ ${chatActivities.authorName}] ${chatActivities.comment} `
//     }
//     let title;
//     switch (chatActivities.liked){
//      case false:
//        title =  `Message Like  `
//        break;
      
//        default: title =  `New message  `
//     }
  
//    const message = {
//     notification: {body: body, title: title},
//     token: androidNotificationToken,
//     data: {recipient: userId},
//    };
//     admin
//    .messaging()
//    .send(message)
//    .then(response => {
//      return console.log('message sent', response);
//    }).catch(error =>{
//     console.log('error sending message', error);
//    })
//  }

// });


// exports.onCreateActivityFollowerNotification = functions.firestore
// .document('/activitiesFollower/{userId}/activitiesFollower/{activitiesFollowerId}')
// .onCreate(async (snapshot, context) => {
//   console.log('activity notification created', snapshot.data());
//   const userId = context.params.userId;
//   const userActivitiesEventId = context.params.userActivitiesEventId;
//   const createdActivityItem = snapshot.data();
//   const usersRef = admin.firestore().doc(`users/${userId}`);
//   const doc = await usersRef.get();
//   const androidNotificationToken = doc.data().androidNotificationToken;


 
//   if(androidNotificationToken){
//    sendNotification(androidNotificationToken, createdActivityItem )
//   } else {
//     console.log('no notification token');
//   }
//   function sendNotification(androidNotificationToken, activitiesFollower )
//  {
//     body = ` ${activitiesFollower.authorName} `
//     title = `New follower  `
  
//    const message = {
//     notification: {body: body, title: title},
//     token: androidNotificationToken,
//     data: {recipient: userId},
//    };
//     admin
//    .messaging()
//    .send(message)
//    .then(response => {
//      return console.log('message sent', response);
//    }).catch(error =>{
//     console.log('error sending message', error);
//    })
//  }

// });




// exports.onCreateActivityAdviceNotification = functions.firestore
// .document('/activitiesAdvice/{userId}/userActivitiesAdvice/{userActivitiesAdviceId}')
// .onCreate(async (snapshot, context) => {
//   console.log('activity notification created', snapshot.data());
//   const userId = context.params.userId;
//   const userActivitiesAdviceId = context.params.userActivitiesAdviceId;
//   const createdActivityItem = snapshot.data();
//   const usersRef = admin.firestore().doc(`users/${userId}`);
//   const doc = await usersRef.get();
//   const androidNotificationToken = doc.data().androidNotificationToken;
 
//   if(androidNotificationToken){
//    sendNotification(androidNotificationToken, createdActivityItem )
//   } else {
//     console.log('no notification token');
//   }
//   function sendNotification(androidNotificationToken, userActivitiesAdvice)
//  {
//     body = `[ ${userActivitiesAdvice.authorName} ] ${userActivitiesAdvice.advice} `
//     title = `New advice  `
  
//    const message = {
//     notification: {body: body, title: title},
//     token: androidNotificationToken,
//     data: {recipient: userId},
//    };
//     admin
//    .messaging()
//    .send(message)
//    .then(response => {
//      return console.log('message sent', response);
//    }).catch(error =>{
//     console.log('error sending message', error);
//    })
//  }

// });

