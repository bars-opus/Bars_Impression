const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const { Message } = require('firebase-functions/lib/providers/pubsub');
const {Storage} = require('@google-cloud/storage');
const firestore = admin.firestore();
const storage = new Storage();
const axios = require('axios');



exports.createSubaccount = functions.https.onCall(async (data, context) => {
  const PAYSTACK_SECRET_KEY = functions.config().paystack.secret_key;
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
  }

  let subaccountCode = null;

  try {
    const paystackResponse = await axios.post('https://api.paystack.co/subaccount', {
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

    if (!paystackResponse.data.status) {
      throw new Error('Subaccount creation failed');
    }

    subaccountCode = paystackResponse.data.data.subaccount_code;

    const recipientResponse = 
    await createTransferRecipient(data, PAYSTACK_SECRET_KEY);
    return { subaccount_id: subaccountCode, recipient_code: recipientResponse };

  } catch (error) {
    alertAdminSubAccountIdFFailure(data.userId, error )
    console.error('Error during subaccount creation or transfer recipient creation:', error);

    // If subaccount creation was successful but transfer recipient creation failed,
    // attempt to delete the subaccount to maintain system consistency.
    if (subaccountCode) {
 
      try {
        await axios.delete(`https://api.paystack.co/subaccount/${subaccountCode}`, {
          headers: {
            Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
            'Content-Type': 'application/json'
          }
        });
        console.log(`Compensation transaction successful: Subaccount ${subaccountCode} deleted.`);
      } catch (compensationError) {
        // alertAdminSubAccountIdFFailure(data.userId, compensationError )
        console.error('Compensation transaction failed:', compensationError);
        // Depending on your error handling policy, you might want to alert an admin here
      }
    }

    // After attempting compensation, rethrow an error to inform the caller that the overall operation failed.
    // alertAdminSubAccountIdFFailure(data.userId, error )
    throw new functions.https.HttpsError('unknown', 'Failed to create transfer recipient, compensation transaction attempted.', error);
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
      currency: data.currency,
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
      alertAdminSubAccountIdFFailure(data.userId, message )
      console.error(message);
      throw new functions.https.HttpsError('unknown', message, response.data);
    }
  } catch (error) {
    alertAdminSubAccountIdFFailure(data.userId, error.response ? error.response.data : error )
    console.error('Error creating transfer recipient:', error.response ? error.response.data : error);
    throw new functions.https.HttpsError(
      'unknown',
      'Error occurred while creating transfer recipient.',
      error.response ? error.response.data : error.message
    );
  }
}













// exports.updateSubaccount = functions.https.onCall(async (data, context) => {
//   const PAYSTACK_SECRET_KEY = functions.config().paystack.secret_key;
//   if (!context.auth) {
//     throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
//   }

//   let subaccountCode = null;

//   try {
//     const paystackResponse = await axios.put(`https://api.paystack.co/subaccount/${data.oldSubaccountId}`, {
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

//     if (!paystackResponse.data.status) {
//       throw new Error('Subaccount creation failed');
//     }

//     subaccountCode = paystackResponse.data.data.subaccount_code;

//     const recipientResponse = await updateTransferRecipient(data, PAYSTACK_SECRET_KEY);
//     return { subaccount_id: subaccountCode, recipient_code: recipientResponse };

//   } catch (error) {
//     alertAdminSubAccountIdFFailure(data.userId, error )
//     console.error('Error during subaccount creation or transfer recipient creation:', error);

//     // If subaccount creation was successful but transfer recipient creation failed,
//     // attempt to delete the subaccount to maintain system consistency.
//     if (subaccountCode) {
//       try {
//         await axios.delete(`https://api.paystack.co/subaccount/${subaccountCode}`, {
//           headers: {
//             Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
//             'Content-Type': 'application/json'
//           }
//         });
//         console.log(`Compensation transaction successful: Subaccount ${subaccountCode} deleted.`);
//       } catch (compensationError) {
//         alertAdminSubAccountIdFFailure(data.userId, compensationError )
//         console.error('Compensation transaction failed:', compensationError);
//         // Depending on your error handling policy, you might want to alert an admin here
//       }
//     }

//     // After attempting compensation, rethrow an error to inform the caller that the overall operation failed.
//     alertAdminSubAccountIdFFailure(data.userId, error )
//     throw new functions.https.HttpsError('unknown', 'Failed to create transfer recipient, compensation transaction attempted.', error);
//   }
// });


// // // Helper function to create a transfer recipient
// async function updateTransferRecipient(data, PAYSTACK_SECRET_KEY) {

//   try {
//     const response = await axios.put(`https://api.paystack.co/transferrecipient/${data.oldTransferRecepientId}`, {
//       // type: "ghipss", // Adjust type as per your requirements
//       name: data.business_name,
//       // account_number: data.account_number,
//       // bank_code: data.bank_code,
//       // currency: 'GHS',
//     }, {
//       headers: {
//         Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
//         'Content-Type': 'application/json'
//       }
//     });

//     // Check if the status is true and the data object contains the recipient_code
//     if (response.data.status ) {
//       return response.data.data.recipient_code;
//     } else {
//       // Provide more detailed error informationy
//       const message = response.data.message || 'Failed to create transfer recipient with Paystack';
//       alertAdminSubAccountIdFFailure(data.userId, message )
//       console.error(message);
//       throw new functions.https.HttpsError('unknown', message, response.data);
//     }
//   } catch (error) {
//     alertAdminSubAccountIdFFailure(data.userId, error.response ? error.response.data : error )
//     console.error('Error creating transfer recipient:', error.response ? error.response.data : error);
//     throw new functions.https.HttpsError(
//       'unknown',
//       'Error occurred while creating transfer recipient.',
//       error.response ? error.response.data : error.message
//     );
//   }
// }






const PAYSTACK_API_BASE_URL = 'https://api.paystack.co';

exports.deletePaystackData = functions.https.onCall(async (data, context) => {
  // Make sure the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
  }

  const subAccountId = data.subAccountId;
  const transferId = data.transferId;

  // Perform the API calls to Paystack
  try {
    await axios({
      method: 'DELETE',
      url: `${PAYSTACK_API_BASE_URL}/subaccount/${subAccountId}`,
      headers: { 'Authorization': `Bearer ${PAYSTACK_SECRET_KEY}` }
    });

    await axios({
      method: 'DELETE',
      url: `${PAYSTACK_API_BASE_URL}/transferrecipient/${transferId}`,
      headers: { 'Authorization': `Bearer ${PAYSTACK_SECRET_KEY}` }
    });

    return { result: 'Paystack data deleted successfully' };
  } catch (error) {
    throw new functions.https.HttpsError('unknown', 'Failed to delete Paystack data', error);
  }
});



function alertAdminSubAccountIdFFailure( userId,  response) {
  const sanitizedResponse = sanitizeResponse(response);
  const logEntry = {
    date: admin.firestore.FieldValue.serverTimestamp(),
    userId: userId,

    response: sanitizedResponse
  };

  const db = admin.firestore();

  const documentPath = getDocumentPath();
  db.collection('subAccount_failures').doc(documentPath).collection('logs').add(logEntry)
    .then(() => console.log('Logged failed with additional details'))
    .catch(error => console.error('Error logging failed:', error));
}




// exports.onInitiatePaystackPayment = functions.https.onCall(async (data, context) => {
//   // Ensure the user is authenticated
//   if (!context.auth) {
//     throw new functions.https.HttpsError('unauthenticated', 'Only authenticated users can make payments.');
//   }

//   const { email, amount, currency, phone, provider } = data;
//   const PAYSTACK_SECRET_KEY =functions.config().paystack.secret_key; // Set this in your Firebase config

//   try {
//     const response = await axios({
//       method: 'post',
//       url: 'https://api.paystack.co/transaction/initialize',
//       headers: {
//         Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
//         'Content-Type': 'application/json',
//       },
//       data: {
//         email,
//         amount: amount * 100, // Amount in kobo
//         currency: 'GHS',
//         mobile_money: {
//           phone,
//           provider,
//         },
//       },
//     });

//     return response.data.data; // Contains authorization_url and access_code
//   } catch (error) {
//     console.error(error);
//     throw new functions.https.HttpsError('internal', 'Unable to initiate payment.');
//   }
// });





exports.initiatePaystackMobileMoneyPayment = functions.https.onCall(async (data, context) => {
  // Ensure the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated to initiate payment.');
  }

  const email = data.email; // Customer's email
  const amount = data.amount; // Amount in kobo
  const reference = data.reference; // Amount in kobo
  const subaccountId = data.subaccountId;
  const callback_url = data.callback_url;
  const bearer = data.bearer;
  const PAYSTACK_SECRET_KEY = functions.config().paystack.secret_key; // Securely stored Paystack secret key

  try {
    const initTransactionURL = 'https://api.paystack.co/transaction/initialize';
    const response = await axios.post(initTransactionURL, {
      email: email,
      amount: amount,
      reference: reference,
      subaccount: subaccountId,
      bearer: bearer,
      callback_url: callback_url,
      currency: "GHS",
      // Add other parameters like callback_url, channels (e.g., ['card', 'bank', 'ussd', 'qr', 'mobilemoney', 'banktransfer']), etc.
    }, {
      headers: { Authorization: `Bearer ${PAYSTACK_SECRET_KEY}` },
    });

    const transactionData = response.data.data;

    // Return the authorization URL to the client to complete the payment
    return { authorizationUrl: transactionData.authorization_url,  success: true,  reference: reference, };
  } catch (error) {
    // Handle errors
    console.error('Payment initiation error:', error);
    // Return a sanitized error message to the client
    throw new functions.https.HttpsError('unknown', 'Payment initiation failed. Please try again later.');
  }
});




exports.verifyPaystackPayment = functions.https.onCall(async (data, context) => {
  // Ensure the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated to verify payment.');
  }

  const paymentReference = data.reference;
  const eventId = data.eventId;
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
    } else {  alertAdminPaymentVerificationFailure(eventId, paymentData, paymentReference )
      // Payment failed or the amount does not match
      return { success: false, message: 'Payment verification failed: Amount does not match or payment was unsuccessful.', transactionData: paymentData };
    }
  } catch (error) {
    // Handle errors
    alertAdminPaymentVerificationFailure(eventId, error, paymentReference )
    console.error('Payment verification error:', error);
    // Return a sanitized error message to the client
    throw new functions.https.HttpsError('unknown', 'Payment verification failed. Please try again later.');
  }
});



function  alertAdminPaymentVerificationFailure( eventId,  response, paymentReference) {
  const sanitizedResponse = sanitizeResponse(response);
  const logEntry = {
    timestamp: new Date(),
    paymentReference: paymentReference,
           eventId: eventId,
        response: sanitizedResponse
  };
  
  const db = admin.firestore();
  const documentPath = getDocumentPath();
  db.collection('ticket_payment_verification_error_logs').doc(documentPath).collection('logs').add(logEntry)
    .then(() => console.log('Logged failed with additional details'))
    .catch(error => console.error('Error logging failed:', error));
}



// function alertAdminPaymentVerificationFailure( eventId,  response) {
//   const sanitizedResponse = sanitizeResponse(response);
//   const logEntry = {
//     timestamp: new Date(),
//        transferRecepientId: eventId,
//        eventId: eventId,
//     response: sanitizedResponse
//   };

//   const db = admin.firestore();
//   const documentPath = getDocumentPath();
//   db.collection('ticket_payment_verification_error_logs').doc(documentPath).collection('logs').add(logEntry)
//     .then(() => console.log('Logged error with additional details'))
//     .catch(error => console.error('Error logging error:', error));
// }
























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
        reason:  `Payment for:  ${ eventData.eventTitle}`, 
      }, {
        headers: {
          'Authorization': `Bearer ${functions.config().paystack.secret_key}`,
          'Content-Type': 'application/json'
        }
      });

      const responseData = response.data;

      if (response.status) {  
           // eslint-disable-next-line no-await-in-loop
      
        return responseData;
      }else {
        // Handle known errors without retrying
        if (responseData.message.includes("Transfer code is invalid")) {
          // eslint-disable-next-line no-await-in-loop
          await alertAdminDistributeFundsError(db,eventData.eventId, eventData.transferRecepientId, eventData.subaccountId, responseData.message ||"Transfer code is invalid" ,  eventData.eventAuthorId, );
          throw new Error(responseData.message);
        }
        // Throw a generic error to trigger a retry for other cases
        throw new Error('Transfer failed with a non-success status');
      }
    
    } catch (error) {
      console.error(`Attempt ${retryCount + 1} for event ${eventDoc.id} failed:`, error);

      if (!isRetryableError(error)) {
           // eslint-disable-next-line no-await-in-loop
        await alertAdminDistributeFundsError(db,eventData.eventId, eventData.transferRecepientId, eventData.subaccountId, error.message || "Unknown error",  eventData.eventAuthorId, );
        throw error;
      }

      console.log(`Retryable error encountered for event ${eventDoc.id}. Will retry after ${delay}ms...`);
      // eslint-disable-next-line no-await-in-loop
      await new Promise(resolve => setTimeout(resolve, delay));
      retryCount++;
      delay *= 2;
    }
  }
  await alertAdminDistributeFundsError(db,eventData.eventId, eventData.transferRecepientId, eventData.subaccountId, 'All retries failed', eventData.eventAuthorId,);
     // eslint-disable-next-line no-await-in-loop
  throw new Error(`All ${maxRetries} retries failed for event ${eventDoc.id}`);
}





  exports.distributeEventFundsWithAffiliate = functions.firestore
  .document('/allFundsPayoutRequest/{requestId}')
  .onCreate(async (snapshot, context) => {


    const db = admin.firestore();
    const eventDoc = snapshot.data();
    const eventId = eventDoc.eventId;
    const eventAuthorId = eventDoc.eventAuthorId;
    const isPrivate = eventDoc.isPrivate;


    const idempotencyKey = eventId;
    const idempotencyDocRef = db.collection('fundsDistributedSuccessIdempotencyKeys').doc(idempotencyKey);
    const eventDocRef = snapshot.ref;

    try {
      // Start a transaction
      await db.runTransaction(async (transaction) => {
        // Check for idempotency inside the transaction
        // eslint-disable-next-line no-await-in-loop
        const idempotencyDoc = await transaction.get(idempotencyDocRef);
        if (idempotencyDoc.exists) {
          // Skip this event as it has already been processed
          return;
        }

        // Attempt to create the transfer with retries
        const response =  await createTransferWithRetry(db, snapshot);
        
        // await


        const userDocRef = db.collection('userPayoutRequests').doc(eventAuthorId).collection('payoutRequests').doc(eventId);
        const userEventDocRef = db.collection('new_events').doc(eventAuthorId).collection('userEvents').doc(eventId);
        const allEventDocRef = isPrivate? null : db.collection('new_allEvents').doc(eventId);

        const total =  response.data.amount;
        // response.data.total; // Assuming this is a number
    
        // If the transfer is successful, mark the event as processed and store the idempotency key
        transaction.update(eventDocRef, { status: 'processed', idempotencyKey: idempotencyKey, total: total, });
        transaction.update(userDocRef, { status: 'processed', idempotencyKey: idempotencyKey, total: total, });
        transaction.update(userEventDocRef, { fundsDistributed: true, });
         // Update allEventDocRef only if it's not null
         if (isPrivate === false) {
          transaction.update(allEventDocRef, { fundsDistributed: true });
        }
        // transaction.update(eventDocRef, { status: 'processed', idempotencyKey: idempotencyKey });
        transaction.set(idempotencyDocRef, {
          transferResponse: response, // Assume the API response has a data field
          created: admin.firestore.FieldValue.serverTimestamp()
        });
      });

      // Alert admin of successful distribution
       alertAdminFundsDistributedSuccess(db, eventId, eventDoc.transferRecepientId, idempotencyKey, eventDoc.subaccountId, eventDoc.eventAuthorId);

      // Send notification if user has a token
      const userData = (await db.doc(`user_general_settings/${eventDoc.eventAuthorId}`).get()).data();
      if (userData && userData.androidNotificationToken) {
        // eslint-disable-next-line no-await-in-loop
        await sendFundDistributedNotification(userData.androidNotificationToken, eventDoc.eventAuthorId, eventId, eventDoc.eventAuthorId, eventDoc.eventTitle);
      } else {
        console.log(`No notification token for user ${eventDoc.eventAuthorId} or notifications are muted.`);
      }
    } catch (error) {
      console.error(`Error processing fund distribution for event ${eventId}:`, error.message);
 
    
      console.error("Config:", error.config);
    
      // Alert admin of error
       alertAdminDistributeFundsError(db, eventId, eventDoc.transferRecepientId, eventDoc.subaccountId, error.message, eventDoc.eventAuthorId);
    }
  });





  exports.distributeAffiliateFunds = functions.firestore
  .document('/allFundsAffiliatePayoutRequest/{requestId}')
  .onCreate(async (snapshot, context) => {

    const db = admin.firestore();
    const affiliateDoc = snapshot.data();
    const affiliateId = affiliateDoc.affiliateId;
    const eventId = affiliateDoc.eventId;


    const idempotencyKey = eventId;
    const idempotencyDocRef = db.collection('fundsAffiliateDistributedSuccessIdempotencyKeys').doc(idempotencyKey);
    const allAffiliateDocRef = snapshot.ref;

    try {
      // Start a transaction
      await db.runTransaction(async (transaction) => {
        // Check for idempotency inside the transaction
        // eslint-disable-next-line no-await-in-loop
        const idempotencyDoc = await transaction.get(idempotencyDocRef);
        if (idempotencyDoc.exists) {
          // Skip this event as it has already been processed
          return;
        }

        // Attempt to create the transfer with retries
        const response =  await createAffiliateTransferWithRetry(db, snapshot);
        
        // await
        const  eventAffiliateDocRef = db.collection('new_eventAffiliate').doc(eventId).collection('affiliateMarketers').doc(affiliateId);
        const  userAffiliateRef = db.collection('userAffiliate').doc(affiliateId).collection('affiliateMarketers').doc(eventId);
        const userAffiliateRequestRef = db.collection('userAffiliatePayoutRequests').doc(affiliateId).collection('payoutRequests').doc(eventId);
        // const allEventDocRef = db.collection('new_allEvents').doc(eventId);

        // const total =  response.data.amount;
        // response.data.total; // Assuming this is a number
    
        // If the transfer is successful, mark the event as processed and store the idempotency key
        transaction.update(allAffiliateDocRef, { status: 'processed', idempotencyKey: idempotencyKey, });
        transaction.update(userAffiliateRequestRef, { status: 'processed', idempotencyKey: idempotencyKey, });

        transaction.update(eventAffiliateDocRef, { payoutToAffiliates: true, });
        transaction.update(userAffiliateRef, { payoutToAffiliates: true, });
        // transaction.update(eventDocRef, { status: 'processed', idempotencyKey: idempotencyKey });
        transaction.set(idempotencyDocRef, {
          transferResponse:  response, // Assume the API response has a data field
          created: admin.firestore.FieldValue.serverTimestamp()
        });
      });

      // Alert admin of successful distribution
      alertAffiliateFundsDistributedSuccess(db, eventId, affiliateDoc.transferRecepientId, idempotencyKey, affiliateDoc.subaccountId, affiliateDoc.eventAuthorId);

      // Send notification if user has a token
      const userData = (await db.doc(`user_general_settings/${affiliateDoc.affiliateId}`).get()).data();
      if (userData && userData.androidNotificationToken) {
        // eslint-disable-next-line no-await-in-loop
        await sendFundDistributedNotification(userData.androidNotificationToken, affiliateDoc.affiliateId, eventId, affiliateDoc.affiliateId, affiliateDoc.eventTitle);
      } else {
        console.log(`No notification token for user ${affiliateDoc.affiliateId} or notifications are muted.`);
      }
    } catch (error) {
      console.error(`Error processing fund distribution for event ${eventId}:`, error.message);
 
    
      console.error("Config:", error.config);
    
      // Alert admin of error
      alertAffiliateDistributeFundsError(db, eventId, affiliateDoc.transferRecepientId, affiliateDoc.subaccountId, error.message, affiliateDoc.eventAuthorId);
    }
  });






async function createAffiliateTransferWithRetry(db, affiliateDoc, maxRetries = 3) {
  let retryCount = 0;
  let delay = 1000; // Initial delay in milliseconds (1 second)
  const affiliateData = affiliateDoc.data();

  while (retryCount < maxRetries) {
    try {
         // eslint-disable-next-line no-await-in-loop
      // const organizerShare = await calculateOrganizerShare(affiliateData);
   // eslint-disable-next-line no-await-in-loop
      const response = await axios.post('https://api.paystack.co/transfer', {
        source: "balance",
        amount: affiliateData.total * 100,
        recipient: affiliateData.transferRecepientId,
        reason:  `Payment to affiliate for:  ${ affiliateData.eventTitle}`, 
      }, {
        headers: {
          'Authorization': `Bearer ${functions.config().paystack.secret_key}`,
          'Content-Type': 'application/json'
        }
      });

      const responseData = response.data;

      if (response.status) {  
           // eslint-disable-next-line no-await-in-loop
      
        return responseData;
      }else {
        // Handle known errors without retrying
        if (responseData.message.includes("Transfer code is invalid")) {
          // eslint-disable-next-line no-await-in-loop
          await alertAffiliateDistributeFundsError(db,affiliateData.eventId, affiliateData.transferRecepientId, affiliateData.subaccountId, responseData.message ||"Transfer code is invalid" ,  affiliateData.affiliateId, );
          throw new Error(responseData.message);
        }
        // Throw a generic error to trigger a retry for other cases
        throw new Error('Transfer failed with a non-success status');
      }
    
    } catch (error) {
      console.error(`Attempt ${retryCount + 1} for event ${eventDoc.id} failed:`, error);

      if (!isRetryableError(error)) {
           // eslint-disable-next-line no-await-in-loop
        await alertAffiliateDistributeFundsError(db,affiliateData.eventId, affiliateData.transferRecepientId, affiliateData.subaccountId, error.message || "Unknown error",  affiliateData.affiliateId, );
        throw error;
      }

      console.log(`Retryable error encountered for event ${eventDoc.id}. Will retry after ${delay}ms...`);
      // eslint-disable-next-line no-await-in-loop
      await new Promise(resolve => setTimeout(resolve, delay));
      retryCount++;
      delay *= 2;
    }
  }
  await alertAffiliateDistributeFundsError(db,affiliateData.eventId, affiliateData.transferRecepientId, affiliateData.subaccountId, 'All retries failed', affiliateData.affiliateId,);
     // eslint-disable-next-line no-await-in-loop
  throw new Error(`All ${maxRetries} retries failed for event ${affiliateDoc.id}`);
}

// async function createTransferWithRetry(db, eventDoc, maxRetries = 3) {
//   let retryCount = 0;
//   let delay = 1000; // Initial delay in milliseconds (1 second)
//   const eventData = eventDoc.data();

//   while (retryCount < maxRetries) {
//     try { 
//          // eslint-disable-next-line no-await-in-loop
//       const organizerShare = await calculateOrganizerShare(eventData);
//    // eslint-disable-next-line no-await-in-loop
//       const response = await axios.post('https://api.paystack.co/transfer', {
//         source: "balance",
//         amount: organizerShare,
//         recipient: eventData.transferRecepientId,
//         reason:  `Payment to organizer for:  ${ eventData.eventTitle}`, 
//       }, {
//         headers: {
//           'Authorization': `Bearer ${functions.config().paystack.secret_key}`,
//           'Content-Type': 'application/json'
//         }
//       });

//       // const responseData = response.data;

//       // response.status

//       if (response.status) {
//            // eslint-disable-next-line no-await-in-loop
//         return response;
//       }else {
//         // Handle known errors without retrying
//         if (response.message.includes("Transfer code is invalid")) {
//           // eslint-disable-next-line no-await-in-loop
//           await alertAdminDistributeFundsError(db,eventData.eventId, eventData.transferRecepientId, eventData.subaccountId, response.message ||"Transfer code is invalid" ,  eventData.eventAuthorId, );
//           throw new Error(response.message);
//         }
//         // Throw a generic error to trigger a retry for other cases
//         throw new Error('Transfer failed with a non-success status');
//       }
    
//     } catch (error) {
//       console.error(`Attempt ${retryCount + 1} for event ${eventDoc.id} failed:`, error);

//       if (!isRetryableError(error)) {
//            // eslint-disable-next-line no-await-in-loop
//         await alertAdminDistributeFundsError(db,eventData.eventId, eventData.transferRecepientId, eventData.subaccountId, error.message || "Unknown error",  eventData.eventAuthorId, );
//         throw error;
//       }

//       console.log(`Retryable error encountered for event ${eventData.id}. Will retry after ${delay}ms...`);
//       // eslint-disable-next-line no-await-in-loop
//       await new Promise(resolve => setTimeout(resolve, delay));
//       retryCount++;
//       delay *= 2;
//     }
//   }
//   await alertAdminDistributeFundsError(db,eventData.eventId, eventData.transferRecepientId, eventData.subaccountId, 'All retries failed', eventData.eventAuthorId,);
//      // eslint-disable-next-line no-await-in-loop
//   throw new Error(`All ${maxRetries} retries failed for event ${eventDoc.eventId}`);
// }





//   exports.distributeEventFunds = functions.firestore
//   .document('/allFundsPayoutRequest/{requestId}')
//   .onCreate(async (snapshot, context) => {
//     const db = admin.firestore();
//     const eventDoc =snapshot;
//     const eventData = eventDoc.data(); 
//     const eventId = eventData.eventId;
//     const transferRecipientId = eventData.transferRecepientId;
//     const eventAuthorId = eventData.eventAuthorId;

//     const idempotencyKey = `payout_${eventId}`;

//     const idempotencyDocRef = db.collection('fundsDistributedSuccessIdempotencyKeys').doc(idempotencyKey);
    // const userDocRef = db.collection('userPayoutRequests').doc(eventAuthorId).collection('payoutRequests').doc(eventId);
    // const userEventDocRef = db.collection('new_events').doc(eventAuthorId).collection('userEvents').doc(eventId);
    // const allEventDocRef = db.collection('new_allEvents').doc(eventId);
//     const allRefundDocRef = snapshot.ref;
//   // First, check if the payout has already been processed
//   const idempotencyDocSnapshot = await idempotencyDocRef.get();
//     if (idempotencyDocSnapshot.exists) {
//       // eslint-disable-next-line no-await-in-loop
//       alertAdminDistributeFundsError(db, eventId, transferRecipientId, eventData.subaccountId, 'funds are already processed', eventData.eventAuthorId);
//      console.log(`Payout already processed for transaction ID: ${transferRecipientId}`);
//      return;
//    }

//     try {
//       // Start a transaction
//       await db.runTransaction(async (transaction) => {
//         // eslint-disable-next-line no-await-in-loop
//         // const idempotencyDoc = await transaction.get(idempotencyDocRef);
//         // if (idempotencyDoc.exists) {
//         //   // Skip this event as it has already been processed
//         //   return;
//         // }  

//         // Attempt to create the transfer with retries
//        // eslint-disable-next-line no-await-in-loop
//         const response = await createTransferWithRetry(db, eventDoc); 
//         // await createTransferWithRetry(db, snapshot); 

//         const  total =  response.data.amount;
//           // response.data.amount/ 90;
//         //  if(response.status)
//         // {
//         // If the transfer is successful, mark the event as processed and store the idempotency key
        // transaction.update(allRefundDocRef, { status: 'processed', idempotencyKey: idempotencyKey, total: total, });
        // transaction.update(userDocRef, { status: 'processed', idempotencyKey: idempotencyKey, total: total, });
        // transaction.update(userEventDocRef, { fundsDistributed: true, });
        // transaction.update(allEventDocRef, { fundsDistributed: true, });

//         transaction.set(idempotencyDocRef, {
//           transferResponse: response, // Assume the API response has a data field
//           created: admin.firestore.FieldValue.serverTimestamp()
//         });
 
//       // Alert admin of successful distribution
//        alertAdminFundsDistributedSuccess(db, eventId, eventData.transferRecepientId, idempotencyKey, eventData.subaccountId, eventData.eventAuthorId);

//        // Send notification if user has a token
//        const userData = (await db.doc(`user_general_settings/${eventData.eventAuthorId}`).get()).data();
//        if (userData && userData.androidNotificationToken) {
//          // eslint-disable-next-line no-await-in-loop
//          await sendFundDistributedNotification(userData.androidNotificationToken, eventData.eventAuthorId, eventId, eventData.eventAuthorId, eventData.eventTitle);
//        } else {
//          console.log(`No notification token for user ${eventData.eventAuthorId} or notifications are muted.`);
//        }
//       //   } else{
//       //     console.error(`Error processing fund distribution for event ${eventId}:`, error);
//       // // Alert admin of error
//       //  alertAdminDistributeFundsError(db, eventId, eventData.transferRecepientId, eventData.subaccountId, error.message || "Unknown error", eventData.eventAuthorId);
//       //   }
//       });
//     } catch (error) {
//       console.error(`Error processing fund distribution for event ${eventId}:`, error.message || "Unknown error",);
//       // Alert admin of error
//        alertAdminDistributeFundsError(db, eventId, eventData.transferRecepientId, eventData.subaccountId,    error.message || "Unknown error", eventData.eventAuthorId);
//     }
//   });





// exports.distributeEventFunds = functions.pubsub.schedule('every 5 minutes').onRun(async (context) => {
//   const db = admin.firestore();
  
//   // Assume this is where you fetch events from Firestore
//   const eventsSnapshot = await db.collection('allFundsPayoutRequest')
//     // .where('clossingDay', '<=', admin.firestore.Timestamp.now())
//     .where('status', '==', 'pending')
//     .get();

//   for (const eventDoc of eventsSnapshot.docs) {
//     const eventData = eventDoc.data();
//     const eventId = eventDoc.data().eventId;

//     const idempotencyKey = `${eventId}_${new Date().toISOString().slice(0, 10)}`;
  
//     const idempotencyDocRef = db.collection('fundsDistributedSuccessIdempotencyKeys').doc(idempotencyKey);
//     const eventDocRef = eventDoc.ref;
  
//     try {
//       // Start a transaction
//        // eslint-disable-next-line no-await-in-loop
//       await db.runTransaction(async (transaction) => {
//         // Check for idempotency inside the transaction
//         const idempotencyDoc = await transaction.get(idempotencyDocRef);
        // if (idempotencyDoc.exists) {
        //   // Skip this event as it has already been processed
        //   return;
        // }
  
//         // Attempt to create the transfer with retries
//          // eslint-disable-next-line no-await-in-loop
//         // const response = await createTransferWithRetry(db, eventDoc);
  
//         // If the transfer is successful, mark the event as processed and store the idempotency key
//         transaction.update(eventDocRef, { status: 'proccessed', idempotencyKey: idempotencyKey });
//         transaction.set(idempotencyDocRef, {
//           transferResponse: 'successful', // Assume the API response has a data field
//           created: admin.firestore.FieldValue.serverTimestamp()
//         });
//       });

//            // eslint-disable-next-line no-await-in-loop
//            await alertAdminFundsDistributedSuccess(db, eventId, eventData.transferRecepientId,idempotencyKey, eventData.subaccountId,  eventData.eventAuthorId,);
      
//       const userId = eventData.eventAuthorId;
//       const userRef = firestore.doc(`user_general_settings/${userId}`);
//         // eslint-disable-next-line no-await-in-loop
//       const userDoc = await userRef.get(); // eslint-disable-next-line no-await-in-loop

//       if (!userDoc.exists) {
//         console.log(`User settings not found for user ${userId}`);
//         // continue;
//       }

//       const userData = userDoc.data();
//       const androidNotificationToken = userData.androidNotificationToken;

//       if (androidNotificationToken) {
//         try {
//             // eslint-disable-next-line no-await-in-loop
//             await sendFundDistributedNotification(androidNotificationToken, userId, eventId, eventData.eventAuthorId, eventData.eventTitle); // eslint-disable-next-line no-await-in-loop
//         } catch (error) {
//           console.error(`Error sending  funds distributed notification:`, error);
//         }
//       } else {
//         console.log(`No notification token for user ${userId} or notifications are muted.`);
//       }
    
    
//     } catch (error) {
//       if (error.response && error.response.data) {
//         transaction.update(eventDocRef, { status: 'error' });
//         if (error.response) {
//           // The request was made and the server responded with a status code
//           // that falls out of the range of 2xx
//           console.error(error.response.data);
//           console.error(error.response.status);
//           console.error(error.response.headers);
//       }
//         console.error(`Attempt ${retryCount + 1} for event ${eventId} failed:`, error.response.data);
    
//         if (error.response.data.code === 'insufficient_balance') {
//           // Handle insufficient balance error specifically
//             // eslint-disable-next-line no-await-in-loop
//           await alertAdminDistributeFundsError(
//             db, 
//             eventId,
//             eventData.transferRecepientId, 
//             eventData.subaccountId, 
//             "Insufficient balance for transfer", 
//             eventData.eventAuthorId
//           );
//           // Break out of the loop since retrying won't resolve insufficient funds
//           break;
//         }
//       } else {
//         transaction.update(eventDocRef, { status: 'error' });
//         // Handle other errors
//            // If the transaction fails, log the error and alert the admin
//       console.error(`Transaction failed for event ${eventId}:`, error);
//       // eslint-disable-next-line no-await-in-loop
//         await alertAdminDistributeFundsError(db, eventId, eventData.transferRecepientId, eventData.subaccountId, `Transaction failed for event:${ eventData.eventTitle} \n ${error}:`, eventData.eventAuthorId, );
//         console.error(`Attempt ${retryCount + 1} for event ${eventDoc.id} failed with an unknown error:`, error);
//       }
     
   
//     }
//   }
// });

function getDocumentPath() {
  const now = new Date();
  const year = now.getFullYear().toString();
  const month = now.toLocaleString('default', { month: 'long' });
  const weekOfMonth = `week${Math.ceil(now.getDate() / 7)}`;
  const path = `${year}/${month}/${weekOfMonth}`;
  
  return path;
}

async function sendFundDistributedNotification(androidNotificationToken, userId, eventId, eventAuthorId, eventTitle) {
  const title = 'Funds payout for event' ;
  const body = eventTitle;
  
  let message = {
  notification: { title, body },
  data: {
  recipient: String(userId),
  contentType: 'FundsDistributed',
  contentId: String(eventId),
  eventAuthorId: String(eventAuthorId),
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




  function alertAffiliateDistributeFundsError(db, eventId, transferRecepientId, subaccountId, response,  authorId) {
    const sanitizedResponse = sanitizeResponse(response);
    const logEntry = {
      date: admin.firestore.FieldValue.serverTimestamp(),
      eventId: eventId,
      // error: errorMessage,
      transferRecepientId: transferRecepientId,
      subaccountId: subaccountId,
      authorId: authorId,
      response: sanitizedResponse
    };
  
    const documentPath = getDocumentPath();
    db.collection('fundAffiliateDistributionFailures').doc(documentPath).collection('logs').add(logEntry)
      .then(() => console.log('Logged failed with additional details'))
      .catch(error => console.error('Error logging failed:', error));
  }


function alertAdminDistributeFundsError(db, eventId, transferRecepientId, subaccountId, response,  authorId) {
  const sanitizedResponse = sanitizeResponse(response);
  const logEntry = {
    date: admin.firestore.FieldValue.serverTimestamp(),
    eventId: eventId,
    // error: errorMessage,
    transferRecepientId: transferRecepientId,
    subaccountId: subaccountId,
    authorId: authorId,
    response: sanitizedResponse
  };

  const documentPath = getDocumentPath();
  db.collection('fundDistributionFailures').doc(documentPath).collection('logs').add(logEntry)
    .then(() => console.log('Logged failed with additional details'))
    .catch(error => console.error('Error logging failed:', error));
}



function alertCalculateFundDistError(db, eventId, transactionId,  subaccountId,response,  authorId,) {
  const sanitizedResponse = sanitizeResponse(response);
  const logEntry = {
    date: admin.firestore.FieldValue.serverTimestamp(),
    eventId: eventId,
    // error: errorMessage,
    transactionId: transactionId,
    authorId: authorId,
    subaccountId: subaccountId,    
    response: sanitizedResponse

  };

  const documentPath = getDocumentPath();
  db.collection('fundCalculateDistributeFailures').doc(documentPath).collection('logs').add(logEntry)
    .then(() => console.log('Logged failed with additional details'))
    .catch(error => console.error('Error logging failed:', error));
}



function alertAffiliateFundsDistributedSuccess(db, eventId, transferRecepientId, idempotencyKey, subaccountId,  authorId, ) {
  // const sanitizedResponse = sanitizeResponse(response);
  const logEntry = {
    date: admin.firestore.FieldValue.serverTimestamp(),
    eventId: eventId,
    transferRecepientId: transferRecepientId,
    authorId: authorId,
    subaccountId: subaccountId,
    idempotencyKey: idempotencyKey
  };

  const documentPath = getDocumentPath();
  db.collection('fundsAffiliatedDistributedSuccess').doc(documentPath).collection('logs').add(logEntry)
    .then(() => console.log('Logged succesful with additional details'))
    .catch(error => console.error('Error logging succesful:', error));
}


function alertAdminFundsDistributedSuccess(db, eventId, transferRecepientId, idempotencyKey, subaccountId,  authorId, ) {
  // const sanitizedResponse = sanitizeResponse(response);
  const logEntry = {
    date: admin.firestore.FieldValue.serverTimestamp(),
    eventId: eventId,
    transferRecepientId: transferRecepientId,
    authorId: authorId,
    subaccountId: subaccountId,
    idempotencyKey: idempotencyKey
  };

  const documentPath = getDocumentPath();
  db.collection('fundsDistributedSuccess').doc(documentPath).collection('logs').add(logEntry)
    .then(() => console.log('Logged succesful with additional details'))
    .catch(error => console.error('Error logging succesful:', error));
}


// // Example function to log success with more details
// function alertAdminFundsDistributedSuccess(eventId, response) {
//   const sanitizedResponse = sanitizeResponse(response);
//   const logEntry = {
//     timestamp: new Date(),
//     eventId: eventId,
//     status: 'Success',
//     response: sanitizedResponse
//   };

//   const db = admin.firestore();
//   const documentPath = getDocumentPath();
//   db.collection('fundsDistributedSuccessLogs').doc(documentPath).collection('logs').add(logEntry)
//     .then(() => console.log('Logged success with additional details'))
//     .catch(error => console.error('Error logging success:', error));
// }

// // Example function to log error with more details
// function alertAdminDistributeFundsError(eventId, transferRecepientId, error, response) {
//   const sanitizedResponse = sanitizeResponse(response);
//   const logEntry = {
//     timestamp: new Date(),
//     eventId: eventId,
//     status: 'Error',
//     transferRecepientId: transferRecepientId,
//     error: error.toString(),
//     response: sanitizedResponse
//   };

//   const db = admin.firestore();
//   const documentPath = getDocumentPath();
//   db.collection('fundDistributionErrorLogs').doc(documentPath).collection('logs').add(logEntry)
//     .then(() => console.log('Logged error with additional details'))
//     .catch(error => console.error('Error logging error:', error));
// }

// // Example function to log error with more details
// function alertCalculateFundDistError(eventId, transferRecepientId, error, response) {
//   const sanitizedResponse = sanitizeResponse(response);
//   const logEntry = {
//     timestamp: new Date(),
//     eventId: eventId,
//     status: 'Error',
//     transferRecepientId: transferRecepientId,
//     error: error.toString(),
//     response: sanitizedResponse
//   };

//   const db = admin.firestore();
//   const documentPath = getDocumentPath();
//   db.collection('fundCalculateErrorLogs').doc(documentPath).collection('logs').add(logEntry)
//     .then(() => console.log('Logged error with additional details'))
//     .catch(error => console.error('Error logging error:', error));
// }

async function calculateOrganizerShare(eventData) {
  const db = admin.firestore();
  try {
    let totalAmountCollected = 0;
    const ticketOrderCollection = admin.firestore()
      .collection('new_eventTicketOrder')
      .doc(eventData.eventId)
      .collection('ticketOrders');
    const totalTicketSnapshot = await ticketOrderCollection.get();

    if (totalTicketSnapshot.empty) {
      console.log(`No ticket orders found for event: ${eventData.eventId}`);
      return 0;
    }

    for (const eventDoc of totalTicketSnapshot.docs) {
      const ticketTotal = eventDoc.data().total;
      if (typeof ticketTotal === 'number' && !isNaN(ticketTotal)) {
        totalAmountCollected += ticketTotal;
      } else {
        console.error(`Invalid ticket total for document: ${eventDoc.id}`);
        // Collect errors for reporting after the loop, if needed
      }
    }

    // Compute the commission and organizer's share
    // Get the total affiliate amount
    const totalAffiliateAmount = eventData.totalAffiliateAmount || 0;

    // Compute the net amount collected after subtracting affiliate payouts
    const netAmountCollected = totalAmountCollected - totalAffiliateAmount;

    // Compute the commission and organizer's share
    const commissionRate = 0.10;
    const commission = netAmountCollected * commissionRate;
    const organizerShare = netAmountCollected - commission;


    if (organizerShare < 0) {
      throw new Error('Calculated organizer share is negative, which is not possible.');
    }

    // Assuming that the organizer's share should be in the smallest currency unit
    return Math.round(organizerShare * 100);
  } catch (error) {

     //  eslint-disable-next-line no-await-in-loop
    await alertCalculateFundDistError(
      
      db,
       eventData.eventId,
      eventData.transferRecepientId,
      eventData.subaccountId,
      `Error calculating organizer share: ${error.message}`,
      eventData.eventAuthorId
    );
    console.error('Error calculating organizer share:', error);
    throw error;
  }
}

// async function calculateOrganizerShare(eventData) {
//   try {
//     // Initialize a variable to hold the sum of all ticket totals
//     let totalAmountCollected = 0;

//     // Get a reference to the subcollection
//     const ticketOrderCollection = admin.firestore()
//       .collection('new_eventTicketOrder')
//       .doc(eventData.id)
//       .collection('ticketOrders');

//     // Retrieve the snapshot
//     const totalTicketSnapshot = await ticketOrderCollection.get();

//     // Check if there are any ticket orders
//     if (totalTicketSnapshot.empty) {
//       console.log(`No ticket orders found for event: ${eventData.id}`);
//       // Handle the scenario where there are no ticket orders, e.g., return 0 or throw an error
//       return 0; // Assuming the organizer's share is zero if there are no ticket sales
//     }

//     // Loop through each document in the snapshot
//     for (const eventDoc of totalTicketSnapshot.docs) {
//       // Accumulate the total amount from each ticket order
//       // Ensure that the total is a number and not undefined or null
//       const ticketTotal = eventDoc.data().total;
//       if (typeof ticketTotal === 'number') {
//         totalAmountCollected += ticketTotal;
//       } else {
//         // Handle the scenario where ticket total is not a number
        //  eslint-disable-next-line no-await-in-loop
//         await alertCalculateFundDistError(db,  eventData.id, eventData.transferRecepientId, eventData.subaccountId, `Invalid ticket total for document: ${String(ticketTotal)}`,  eventData.authorId, );
//         console.error(`Invalid ticket total for document: ${eventDoc.id}`);
//         // Depending on your error handling strategy, you can throw an error or skip this ticket total
//         // throw new Error(`Invalid ticket total for document: ${eventDoc.id}`);
//       }
//     }

//     // Calculate your commission (10% of the total amount)
//     const commissionRate = 0.10; // 10% commission rate
//     const commission = totalAmountCollected * commissionRate;

//     // The organizer's share is the remaining 90%
//     const organizerShare = totalAmountCollected - commission;

//     // Ensure the organizer's share is not negative
//     if (organizerShare < 0) {
//       throw new Error('Calculated organizer share is negative, which is not possible.');
//     }

//     // Return the organizer's share
//     return Math.round(organizerShare * 100);

//     // return organizerShare;

//   } catch (error) {
//     // Use eventData.id instead of eventDoc.id to avoid referencing an undefined variable
//     await alertCalculateFundDistError(db,  eventData.id, eventData.transferRecepientId, eventData.subaccountId, `Error calculating organizer share: ${error.message.toString()}`, eventData.authorId, );
//     console.error('Error calculating organizer share:', error);
//     throw error;
//   }
// }



// List of fields in the response that should be sanitized
const sensitiveFields = [
  'account_number',
  'account_name',
  'authorization_code',
  'card_number',
  'cvv',
  'expiry_month',
  'expiry_year',
  'transaction_id',
  // Add any other sensitive fields that may be present in the response
];

// Helper function to recursively sanitize sensitive fields in an object
function sanitize(obj) {
  if (Array.isArray(obj)) {
      obj.forEach(sanitize);
  } else {
      for (const key in obj) {
          if (sensitiveFields.includes(key)) {
              obj[key] = '***SENSITIVE_DATA***';
          } else if (typeof obj[key] === 'object' && obj[key] !== null) {
              sanitize(obj[key]);
          }
      }
  }
}

function sanitizeResponse(response) {
  // Clone the response to avoid mutating the original
  const clonedResponse = JSON.parse(JSON.stringify(response));
  sanitize(clonedResponse);
  return clonedResponse;
}

  

exports.scheduledRefundProcessor = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
   // eslint-disable-next-line no-await-in-loop
   const db = admin.firestore();

  const refundRequestsSnapshot = await db.collection('allRefundRequests').where('status', '==', 'pending').get();

  for (const refundRequestDoc of refundRequestsSnapshot.docs) {

  const refundData = refundRequestDoc.data();
    try { // eslint-disable-next-line no-await-in-loop
      await processRefund(refundRequestDoc);
    } catch (error) {
      console.error(`Error processing refund for transaction ID: ${refundRequestDoc.id}`, error);
      // Handle the error appropriately, e.g., alert the admin
       // eslint-disable-next-line no-await-in-loop
      await alertAdminRefundFailure(db, refundRequestDoc.data().eventId, refundRequestDoc.data().transactionId, error.message, refundData.userRequestId, refundData.orderId,);
    }
  }
});

async function processRefund(refundRequestDoc) {
  const db = admin.firestore();

  const refundData = refundRequestDoc.data();
  const transactionId = refundData.transactionId;
  // const transferUserId =   refundData.userRequestId;
  const eventId = refundData.eventId;
  // Assuming refundData.amount is in Naira, convert to kobo
const amountInKobo = refundData.amount * 100;
// Calculate 80% of the original amount
const refundRate = 0.80;
const refundAmount = Math.floor(amountInKobo * refundRate);
  //  const commissionRate = refundData.amount * 0.20;
  // const refundAmount = Math.floor(commissionRate * 100); // 80% of the original amount
  const idempotencyKey = `refund_${transactionId}`;


  const idempotencyDocRef = db.collection('refundSuccessIdempotencyKeys').doc(idempotencyKey);

  // First, check if the refund has already been processed
  const idempotencyDocSnapshot = await idempotencyDocRef.get();
  if (idempotencyDocSnapshot.exists) {
     // eslint-disable-next-line no-await-in-loop 
    await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,);
    console.log(`Refund already processed for transaction ID: ${transactionId}`);
    return;
  }

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
      const response =  await axios.post('https://api.paystack.co/refund', payload, { headers });
      
      // await axios.post('https://api.paystack.co/refund', payload, { headers });
    
      // response.data.status
      if ( response.data.status) {
         
        const   amount = response.data.data.amount/100;
        // response.data.amount/100;
        const  expectedDate = response.data.data.expected_at;
        // response.data.expected_at;
         // eslint-disable-next-line no-await-in-loop
        await db.runTransaction(async (transaction) => {

          const transferUserId = refundData.userRequestId;
          const userId = transferUserId;


   
        
          const refundRequestRef = refundRequestDoc.ref;
          const idempotencyDocRef = db.collection('refundSuccessIdempotencyKeys').doc(idempotencyKey);
          const eventDocRef = db.collection('new_eventTicketOrder').doc(refundData.eventId).collection('ticketOrders').doc(userId);
          const userDocRef = db.collection('new_userTicketOrder').doc(userId).collection('ticketOrders').doc(refundData.eventId);
          const userTicketIdRef = db.collection('new_ticketId').doc(userId).collection('tickedIds').doc(refundData.eventId);
          const userRefundRequestRef = db.collection('userRefundRequests').doc(userId).collection('refundRequests').doc(refundData.eventId);
          const eventRefundRequestRef = db.collection('eventRefundRequests').doc(refundData.eventId).collection('refundRequests').doc(userId);
          // const idempotencyDocSnapshot = await transaction.get(idempotencyDocRef);

          // if (!idempotencyDocSnapshot.exists) {
            transaction.update(refundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey,  amount:  amount, expectedDate: expectedDate  });
            transaction.update(eventDocRef, { refundRequestStatus: 'processed', idempotencyKey: idempotencyKey  });
            transaction.update(userDocRef, { refundRequestStatus: 'processed', idempotencyKey: idempotencyKey  });
            transaction.update(userRefundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey, amount:  amount, expectedDate: expectedDate  });
            transaction.update(eventRefundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey, amount:  amount, expectedDate: expectedDate  });
            transaction.delete(userTicketIdRef);
            transaction.set(idempotencyDocRef, {
              refundResponse: response.data,
              // response.data,
              created: admin.firestore.FieldValue.serverTimestamp()
            });

           
            const userRef = firestore.doc(`user_general_settings/${userId}`);
              // eslint-disable-next-line no-await-in-loop
            const userDoc = await userRef.get(); // eslint-disable-next-line no-await-in-loop
  
            if (!userDoc.exists) {
              console.log(`User settings not found for user ${userId}`);
              // continue;
            }
  
            const userData = userDoc.data();
            const androidNotificationToken = userData.androidNotificationToken;
  
            if (androidNotificationToken) {
              try {
                  // eslint-disable-next-line no-await-in-loop
                await sendRefundNotification(androidNotificationToken, userId, refundData.eventId, refundData.eventAuthorId, refundData.eventTitle ); // eslint-disable-next-line no-await-in-loop
              } catch (error) {
                console.error(`Error sending seding refund notification:`, error);
              }
            } else {
              console.log(`No notification token for user ${userId} or notifications are muted.`);
            }

          // } else {
          //      // eslint-disable-next-line no-await-in-loop
          //   await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,);
          //   console.log(`Refund already processed for transaction ID: ${transactionId}`);
          //   return;
          // }
        });
         // eslint-disable-next-line no-await-in-loop
         await alertAdminRefundSuccess(db, eventId, transactionId, idempotencyKey, refundData.userRequestId, refundData.orderId,);
        console.log(`Refund processed for transaction ID: ${transactionId}`);
        return;
      } else {
          // eslint-disable-next-line no-await-in-loop
        await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,);
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
        await alertAdminRefundFailure(db, eventId, transactionId, `Max retry attempts reached. Last error: ${error.message}`, refundData.userRequestId, refundData.orderId,);
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
    await alertAdminRefundFailure(db, eventId, transactionId, 'All retry attempts failed', refundData.userRequestId, refundData.orderId, );
    throw new Error(`All retry attempts failed for refund ${transactionId}`);
  }
}




async function sendRefundNotification(androidNotificationToken, userId, eventId, eventAuthorId, subtitle) {
  const title = 'Refund processed' ;
  const body = subtitle;
  
  let message = {
  notification: { title, body },
  data: {
  recipient: String(userId),
  contentType: 'refundProcessed',
  contentId: String(eventId),
  eventAuthorId: String(eventAuthorId),
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


  




function alertAdminRefundFailure(db, eventId, transactionId, response, userRequestId, orderId) {
  const sanitizedResponse = sanitizeResponse(response);
  const logEntry = {
    date: admin.firestore.FieldValue.serverTimestamp(),
    eventId: eventId,
    // error: errorMessage,
    transactionId: transactionId,
    userRequestId: userRequestId,
    orderId: orderId,
    response: sanitizedResponse
  };

  const documentPath = getDocumentPath();
  db.collection('refundFailures').doc(documentPath).collection('logs').add(logEntry)
    .then(() => console.log('Logged failed with additional details'))
    .catch(error => console.error('Error logging failed:', error));
}



function alertAdminRefundSuccess(db, eventId, transactionId, idempotencyKey,  userRequestId, orderId ) {
  // const sanitizedResponse = sanitizeResponse(response);
  const logEntry = {
    date: admin.firestore.FieldValue.serverTimestamp(),
    eventId: eventId,
    transactionId: transactionId,
    userRequestId: userRequestId,
    orderId: orderId,
    idempotencyKey: idempotencyKey
  };

  const documentPath = getDocumentPath();
  db.collection('refundSuccess').doc(documentPath).collection('logs').add(logEntry)
    .then(() => console.log('Logged succesful with additional details'))
    .catch(error => console.error('Error logging succesful:', error));
}


// exports.scheduledRefundEventDeletedProcessor = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
//   // eslint-disable-next-line no-await-in-loop
//   const db = admin.firestore();

//  const refundRequestsSnapshot = await db.collection('allRefundRequestsEventDeleted').where('status', '==', 'pending').get();

//  for (const refundRequestDoc of refundRequestsSnapshot.docs) {
//   const refundData = refundRequestDoc.data();

//    try { // eslint-disable-next-line no-await-in-loop
//      await processRefundEventDeleted(refundRequestDoc);
//    } catch (error) {
//      console.error(`Error processing refund for transaction ID: ${refundRequestDoc.id}`, error);
//      // Handle the error appropriately, e.g., alert the admin
//       // eslint-disable-next-line no-await-in-loop
//      await alertAdminRefundFailure(db, refundRequestDoc.data().eventId, refundRequestDoc.data().transactionId, error.message, refundData.userRequestId, refundData.orderId,);
//    }
//  }
// });

exports.scheduledRefundEventDeletedProcessor = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
  // eslint-disable-next-line no-await-in-loop
  const db = admin.firestore();

 const refundRequestsSnapshot = await db.collection('allRefundRequestsEventDeleted').where('status', '==', 'pending').get();

 for (const refundRequestDoc of refundRequestsSnapshot.docs) {

 const refundData = refundRequestDoc.data();
   try { // eslint-disable-next-line no-await-in-loop
     await processRefundEventDeleted(refundRequestDoc);
   } catch (error) {
     console.error(`Error processing refund for transaction ID: ${refundRequestDoc.id}`, error);
     // Handle the error appropriately, e.g., alert the admin
      // eslint-disable-next-line no-await-in-loop
     await alertAdminRefundFailure(db, refundRequestDoc.data().eventId, refundRequestDoc.data().transactionId, error.message, refundData.userRequestId, refundData.orderId,);
   }
 }
});



async function processRefundEventDeleted(refundRequestDoc) {
  const db = admin.firestore();

  const refundData = refundRequestDoc.data();
  const transactionId = refundData.transactionId;
  // const transferUserId =   refundData.userRequestId;
  const eventId = refundData.eventId;
  // Assuming refundData.amount is in Naira, convert to kobo
const amountInKobo = refundData.amount * 100;
// Calculate 80% of the original amount

const refundAmount = Math.floor(amountInKobo);
  //  const commissionRate = refundData.amount * 0.20;
  // const refundAmount = Math.floor(commissionRate * 100); // 80% of the original amount
  const idempotencyKey = `refund_${transactionId}`;


  const idempotencyDocRef = db.collection('refundSuccessIdempotencyKeys').doc(idempotencyKey);

  // First, check if the refund has already been processed
  const idempotencyDocSnapshot = await idempotencyDocRef.get();
  if (idempotencyDocSnapshot.exists) {
     // eslint-disable-next-line no-await-in-loop 
    await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,);
    console.log(`Refund already processed for transaction ID: ${transactionId}`);
    return;
  }

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
      const response =  await axios.post('https://api.paystack.co/refund', payload, { headers });
      
      // await axios.post('https://api.paystack.co/refund', payload, { headers });
    
      // response.data.status
      if ( response.data.status) {
         
        const   amount = response.data.data.amount/100;
        // response.data.amount/100;
        const  expectedDate = response.data.data.expected_at;
        // response.data.expected_at;
         // eslint-disable-next-line no-await-in-loop
        await db.runTransaction(async (transaction) => {

          const transferUserId = refundData.userRequestId;
          const userId = transferUserId;


   
        
          const refundRequestRef = refundRequestDoc.ref;
          const idempotencyDocRef = db.collection('refundSuccessIdempotencyKeys').doc(idempotencyKey);
          // const eventDocRef = db.collection('new_eventTicketOrder').doc(refundData.eventId).collection('ticketOrders').doc(userId);
          const userDocRef = db.collection('new_userTicketOrder').doc(userId).collection('ticketOrders').doc(refundData.eventId);
          // const userTicketIdRef = db.collection('new_ticketId').doc(userId).collection('tickedIds').doc(refundData.eventId);
          const userRefundRequestRef = db.collection('userRefundRequests').doc(userId).collection('refundRequests').doc(refundData.eventId);
          // const eventRefundRequestRef = db.collection('eventRefundRequests').doc(refundData.eventId).collection('refundRequests').doc(userId);
          // const idempotencyDocSnapshot = await transaction.get(idempotencyDocRef);

          // if (!idempotencyDocSnapshot.exists) {
            transaction.update(refundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey,  amount:  amount, expectedDate: expectedDate  });
            // transaction.update(eventDocRef, { refundRequestStatus: 'processed', idempotencyKey: idempotencyKey  });
            transaction.update(userDocRef, { refundRequestStatus: 'processed', idempotencyKey: idempotencyKey  });
            transaction.update(userRefundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey, amount:  amount, expectedDate: expectedDate  });
            // transaction.update(eventRefundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey, amount:  amount, expectedDate: expectedDate  });
            // transaction.delete(userTicketIdRef);
            transaction.set(idempotencyDocRef, {
              refundResponse: response.data,
              // response.data,
              created: admin.firestore.FieldValue.serverTimestamp()
            });

           
            const userRef = firestore.doc(`user_general_settings/${userId}`);
              // eslint-disable-next-line no-await-in-loop
            const userDoc = await userRef.get(); // eslint-disable-next-line no-await-in-loop
  
            if (!userDoc.exists) {
              console.log(`User settings not found for user ${userId}`);
              // continue;
            }
  
            const userData = userDoc.data();
            const androidNotificationToken = userData.androidNotificationToken;
  
            if (androidNotificationToken) {
              try {
                  // eslint-disable-next-line no-await-in-loop
                await sendRefundNotification(androidNotificationToken, userId, refundData.eventId, refundData.eventAuthorId, refundData.eventTitle ); // eslint-disable-next-line no-await-in-loop
              } catch (error) {
                console.error(`Error sending seding refund notification:`, error);
              }
            } else {
              console.log(`No notification token for user ${userId} or notifications are muted.`);
            }

          // } else {
          //      // eslint-disable-next-line no-await-in-loop
          //   await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,);
          //   console.log(`Refund already processed for transaction ID: ${transactionId}`);
          //   return;
          // }
        });
         // eslint-disable-next-line no-await-in-loop
         await alertAdminRefundSuccess(db, eventId, transactionId, idempotencyKey, refundData.userRequestId, refundData.orderId,);
        console.log(`Refund processed for transaction ID: ${transactionId}`);
        return;
      } else {
          // eslint-disable-next-line no-await-in-loop
        await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,);
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
        await alertAdminRefundFailure(db, eventId, transactionId, `Max retry attempts reached. Last error: ${error.message}`, refundData.userRequestId, refundData.orderId,);
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
    await alertAdminRefundFailure(db, eventId, transactionId, 'All retry attempts failed', refundData.userRequestId, refundData.orderId, );
    throw new Error(`All retry attempts failed for refund ${transactionId}`);
  }
}





// async function processRefundEventDeleted(refundRequestDoc) {
//  const db = admin.firestore();

//  const refundData = refundRequestDoc.data();
//  const transactionId = refundData.transactionId;
//  const eventId = refundData.eventId;
// //  const userId = refundData.userRequestId;
//  const refundAmount = Math.floor(refundData.amount * 100); 
//  const idempotencyKey = `refund_${transactionId}`;


//  const idempotencyDocRef = db.collection('refundSuccessIdempotencyKeys').doc(idempotencyKey);

//  // First, check if the refund has already been processed
//  const idempotencyDocSnapshot = await idempotencyDocRef.get();
//  if (idempotencyDocSnapshot.exists) {
//     // eslint-disable-next-line no-await-in-loop 
//    await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,);
//    console.log(`Refund already processed for transaction ID: ${transactionId}`);
//    return;
//  }

//  const payload = {
//    transaction: transactionId,
//    amount: refundAmount
//  };

//  const headers = {
//    'Authorization': `Bearer ${functions.config().paystack.secret_key}`,
//    'Content-Type': 'application/json'
//  };

//  let retryCount = 0;
//  let delay = 1000; // 1 second initial delay
//  const maxRetries = 3;
//  const MAX_DELAY = 30000; // Maximum delay for exponential backoff, e.g., 30 seconds

//  while (retryCount < maxRetries) {
//    try {
//       // eslint-disable-next-line no-await-in-loop
//      const response = await axios.post('https://api.paystack.co/refund', payload, { headers });

//      if (response.data.status) {
//       const   amount = response.data.data.amount/100;
//       // response.data.amount/100;
//       const  expectedDate = response.data.data.expected_at;
//       // response.data.expected_at;
//        // eslint-disable-next-line no-await-in-loop
//       await db.runTransaction(async (transaction) => {


//         const transferUserId = refundData.userRequestId;

//         const userId = transferUserId;

//         const refundRequestRef = refundRequestDoc.ref;
//         const idempotencyDocRef = db.collection('refundSuccessIdempotencyKeys').doc(idempotencyKey);
//         const eventDocRef = db.collection('new_eventTicketOrder').doc(refundData.eventId).collection('ticketOrders').doc(userId);
//         const userDocRef = db.collection('new_userTicketOrder').doc(userId).collection('ticketOrders').doc(refundData.eventId);
       
//         // const userTicketIdRef = db.collection('new_ticketId').doc(userId).collection('tickedIds').doc(refundData.eventId);
//         const userRefundRequestRef = db.collection('userRefundRequests').doc(userId).collection('refundRequests').doc(refundData.eventId);
//         // const eventRefundRequestRef = db.collection('eventRefundRequests').doc(refundData.eventId).collection('refundRequests').doc(userId);
//         // const idempotencyDocSnapshot = await transaction.get(idempotencyDocRef);

//         // if (!idempotencyDocSnapshot.exists) {
//           transaction.update(refundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey,  amount:  amount, expectedDate: expectedDate  });
//           transaction.update(eventDocRef, { refundRequestStatus: 'processed', idempotencyKey: idempotencyKey  });
//           transaction.update(userDocRef, { refundRequestStatus: 'processed', idempotencyKey: idempotencyKey  });
//           transaction.update(userRefundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey, amount:  amount, expectedDate: expectedDate  });
//           // transaction.update(eventRefundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey, amount:  amount, expectedDate: expectedDate  });
//           // transaction.delete(userTicketIdRef);
//           transaction.set(idempotencyDocRef, {
//             refundResponse: response.data,
//             // response.data,
//             created: admin.firestore.FieldValue.serverTimestamp()
//           });

         
//           const userRef = firestore.doc(`user_general_settings/${userId}`);
//             // eslint-disable-next-line no-await-in-loop
//           const userDoc = await userRef.get(); // eslint-disable-next-line no-await-in-loop

//           if (!userDoc.exists) {
//             console.log(`User settings not found for user ${userId}`);
//             // continue;
//           }

//           const userData = userDoc.data();
//           const androidNotificationToken = userData.androidNotificationToken;

//           if (androidNotificationToken) {
//             try {
//                 // eslint-disable-next-line no-await-in-loop
//               await sendRefundNotification(androidNotificationToken, userId, refundData.eventId, refundData.eventAuthorId, refundData.eventTitle ); // eslint-disable-next-line no-await-in-loop
//             } catch (error) {
//               console.error(`Error sending seding refund notification:`, error);
//             }
//           } else {
//             console.log(`No notification token for user ${userId} or notifications are muted.`);
//           }


//        });
//         // eslint-disable-next-line no-await-in-loop
//         await alertAdminRefundSuccess(db, eventId, transactionId, idempotencyKey, refundData.userRequestId, refundData.orderId,);
//         // await alertAdminRefundSuccess(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,);
//        console.log(`Refund processed for transaction ID: ${transactionId}`);
//        return;
//      } else {
//         // eslint-disable-next-line no-await-in-loop
//       await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,); 
//        throw new Error('Refund failed with a non-success status');
//      }
//    } catch (error) {
//       // eslint-disable-next-line no-await-in-loop
//     await alertAdminRefundFailure(db, eventId, transactionId,  error.message); 
//      console.error(`Attempt ${retryCount + 1} for refund ${transactionId} failed:`, error, refundData.userRequestId, refundData.orderId,);

//      if (!isRetryableError(error)) {
//         // eslint-disable-next-line no-await-in-loop
//        await refundRequestDoc.ref.update({ status: 'error' });
//         // eslint-disable-next-line no-await-in-loop
//          await alertAdminRefundFailure(db, eventId, transactionId, error.message, refundData.userRequestId, refundData.orderId,);
//        throw error; // Non-retryable error, rethrow error
//      }

//      if (retryCount === maxRetries - 1) {
//         // eslint-disable-next-line no-await-in-loop
//        await alertAdminRefundFailure(db, eventId, transactionId, `Max retry attempts reached. Last error: ${error.message}`, refundData.userRequestId, refundData.orderId,);
//      }

//      // Exponential backoff with a maximum delay cap
//      delay = Math.min(delay * 2, MAX_DELAY);
//      console.log(`Retryable error encountered for refund ${transactionId}. Retrying after ${delay}ms...`);
//       // eslint-disable-next-line no-await-in-loop
//      await new Promise(resolve => setTimeout(resolve, delay));
//      retryCount++;
//    }
//  }

//  if (retryCount >= maxRetries) {
//     // eslint-disable-next-line no-await-in-loop
//    await refundRequestDoc.ref.update({ status: 'failed' });
//     // eslint-disable-next-line no-await-in-loop
//    await alertAdminRefundFailure(db, eventId, transactionId, 'All retry attempts failed', refundData.userRequestId, refundData.orderId,);
//    throw new Error(`All retry attempts failed for refund ${transactionId}`);
//  }
// }





        
        // const refundRequestRef = refundRequestDoc.ref;
        // const userRefundRequestRef = db.collection('userRefundRequests').doc(userId).collection('refundRequests').doc(refundData.eventId);
        // const idempotencyDocRef = db.collection('refundSuccessIdempotencyKeys').doc(idempotencyKey);
        // const eventDocRef = db.collection('new_eventTicketOrder').doc(refundData.eventId).collection('eventInvite').doc(userId);
        // const userDocRef = db.collection('new_userTicketOrder').doc(userId).collection('eventInvite').doc(refundData.eventId);
        // const userTicketIdRef = db.collection('new_ticketId').doc(userId).collection('tickedIds').doc(refundData.eventId);
        
        //  const idempotencyDocRef = db.collection('refundSuccessIdempotencyKeys').doc(idempotencyKey);
        // //  const eventDocRef = db.collection('new_eventTicketOrder').doc(refundData.eventId).collection('eventInvite').doc(refundData.userRequestId);
        //  const userDocRef = db.collection('new_userTicketOrder').doc(refundData.userRequestId).collection('eventInvite').doc(refundData.eventId);
        //  const userTicketIdRef = db.collection('new_ticketId').doc(refundData.userRequestId).collection('eventInvite').doc(refundData.eventId);
        //  const idempotencyDocSnapshot = await transaction.get(idempotencyDocRef);

        //  if (!idempotencyDocSnapshot.exists) {
          //             transaction.update(refundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey,  amount:  amount, expectedDate: expectedDate  });
          // //  transaction.update(refundRequestRef, { status: 'processed' });
          //  transaction.update(eventDocRef, { refundRequestStatus: 'processed', idempotencyKey: idempotencyKey  });
          //  transaction.update(userRefundRequestRef, { status: 'processed', idempotencyKey: idempotencyKey, amount:  amount, expectedDate: expectedDate  });

          // //  transaction.update(eventDocRef, { refundRequestStatus: 'processed' });
          //  transaction.update(userDocRef, { refundRequestStatus: 'processed', idempotencyKey: idempotencyKey });
          //  transaction.delete(userTicketIdRef);
          //  transaction.set(idempotencyDocRef, {
          //    refundResponse: response.data,
          //    created: admin.firestore.FieldValue.serverTimestamp()
          //  });
          // //  const userId = refundData.userRequestId;
          //  const userRef = firestore.doc(`user_general_settings/${userId}`);
          //    // eslint-disable-next-line no-await-in-loop
          //  const userDoc = await userRef.get(); // eslint-disable-next-line no-await-in-loop
 
          //  if (!userDoc.exists) {
          //    console.log(`User settings not found for user ${userId}`);
          //    // continue;
          //  }
 
          //  const userData = userDoc.data();
          //  const androidNotificationToken = userData.androidNotificationToken;
 
          //  if (androidNotificationToken) {
          //    try {
          //        // eslint-disable-next-line no-await-in-loop
          //      await sendRefundNotification(androidNotificationToken, userId, refundData.eventId, refundData.eventAuthorId, 'Refund processed for a deleted event.'); // eslint-disable-next-line no-await-in-loop
          //    } catch (error) {
          //      console.error(`Error sending seding refund notification:`, error);
          //    }
          //  } else {
          //    console.log(`No notification token for user ${userId} or notifications are muted.`);
          //  }
        //  } else {  
        //     // eslint-disable-next-line no-await-in-loop
        //   await alertAdminRefundFailure(db, eventId, transactionId, response.data, refundData.userRequestId, refundData.orderId,); 
        //    console.log(`Refund already processed for transaction ID: ${transactionId}`);
        //    return;
        //  }




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
          .collection('ticketOrders')
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
      eventAuthorId: String(event.authorId),

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
    if( snapshot.data().showToFollowers ){
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
    }
    
  });



// exports.onDeleteFeedEvent = functions.firestore
//   .document('/new_events/{userId}/userEvents/{eventId}')
//   .onDelete(async (snapshot, context) => {
//     const userId = context.params.userId;
//     const eventId = context.params.eventId;
//     console.log(snapshot.data());
//     const userFollowersRef = admin
//       .firestore()
//       .collection('new_followers')
//       .doc(userId)
//       .collection('userFollowers');
//     const userFollowersSnapshot = await userFollowersRef.get();

//     const batch = admin.firestore().batch();

//     userFollowersSnapshot.forEach((doc) => {
//       const followerId = doc.id;
//       const eventFeedRef = admin
//         .firestore()
//         .collection('new_eventFeeds')
//         .doc(followerId)
//         .collection('userEventFeed')
//         .doc(eventId);
//       batch.delete(eventFeedRef);
//     });


    
//     // Commit the batch operation to delete all follower documents
//     await batch.commit();

//     // Delete the event from the 'allEvents' collection
//    admin.firestore().collection('new_events').doc(eventId).delete();
//    admin.firestore().collection('new_eventChatRooms').doc(eventId).delete();
//    admin.firestore().collection('new_eventTicketOrder').doc(eventId).collection('eventInvite').doc(userId).delete();
//    admin.firestore().collection('new_eventChatRoomsConversation').doc(eventId).collection('roomChats').doc(userId).delete();
//   });


// exports.onDeleteFeedEvent = functions.firestore
//   .document('/new_events/{userId}/userEvents/{eventId}')
//   .onDelete(async (snapshot, context) => {
//     const { userId, eventId } = context.params;

//     // References to user followers
//     const userFollowersRef = admin.firestore().collection('new_followers').doc(userId).collection('userFollowers');
    
//     // Delete related documents from userEventFeed of each follower
//     const userFollowersSnapshot = await userFollowersRef.get();
//     let batch = admin.firestore().batch();

//     for (const doc of userFollowersSnapshot.docs) {
//       if (batch._opCount >= 499) {
//         // eslint-disable-next-line no-await-in-loop
//         await batch.commit();
//         batch = admin.firestore().batch();
//       }
//       const followerId = doc.id;
//       const eventFeedRef = admin.firestore().collection('new_eventFeeds').doc(followerId).collection('userEventFeed').doc(eventId);
//        // eslint-disable-next-line no-await-in-loop
      
//       batch.delete(eventFeedRef);
      
//     }

//     const allEventRef = admin.firestore().collection('new_allEvents').doc(eventId);
//     batch.delete(allEventRef);
//     await batch.commit();

  
//     // Delete the eventChatRooms document
//  // eslint-disable-next-line no-await-in-loop
//     await admin.firestore().collection('new_eventChatRooms').doc(eventId).delete();

//     // Delete all documents in ticketOrder subcollection
//     const ticketOrdeRef = admin.firestore().collection('new_eventTicketOrder').doc(eventId).collection('eventInvite');
//     // eslint-disable-next-line no-await-in-loop
//     await deleteCollection(ticketOrdeRef);

//     // Delete all documents in ticketOrde subcollection
//     const eventInviteRef = admin.firestore().collection('new_sentEventInvite').doc(eventId).collection('eventInvite');
//     await deleteCollection(eventInviteRef);


//       // Delete all documents in ticketOrde subcollection
//       const askRef = admin.firestore().collection('new_asks').doc(eventId).collection('eventAsks');
//       // eslint-disable-next-line no-await-in-loop
//       await deleteCollection(askRef);


//     // Delete all documents in roomChats subcollection
//     const roomChatsRef = admin.firestore().collection('new_eventChatRoomsConversation').doc(eventId).collection('roomChats');
//     // eslint-disable-next-line no-await-in-loop
//     await deleteCollection(roomChatsRef);
//   });



// // Helper function to delete all documents in a collection or subcollection
// async function deleteCollection(collectionRef) {
//   const snapshot = await collectionRef.get();

//   if (snapshot.size === 0) {
//     return;
//   }

//   // Delete documents in batches
//   let batch = admin.firestore().batch();
//   let count = 0;
//   for (const doc of snapshot.docs) {
//     batch.delete(doc.ref);
//     count++;
//     if (count % 499 === 0) {
//       // eslint-disable-next-line no-await-in-loop
//       await batch.commit();
//       batch = admin.firestore().batch();
//     }
//   }

//   await batch.commit();
// }



exports.onDeleteFeedEvent = functions.firestore
  .document('/new_events/{userId}/userEvents/{eventId}')
  .onDelete(async (snapshot, context) => {
    const { userId, eventId } = context.params;

    // References to user followers
    const userFollowersRef = admin.firestore().collection('new_followers').doc(userId).collection('userFollowers');

    // Delete related documents from userEventFeed of each follower
     // eslint-disable-next-line no-await-in-loop
    const userFollowersSnapshot = await userFollowersRef.get();
    let batch = admin.firestore().batch();
    let operationCount = 0;

    for (const doc of userFollowersSnapshot.docs) {
      const followerId = doc.id;
      const eventFeedRef = admin.firestore().collection('new_eventFeeds').doc(followerId).collection('userEventFeed').doc(eventId);
      batch.delete(eventFeedRef);
      operationCount++;

      if (operationCount >= 499) {
         // eslint-disable-next-line no-await-in-loop
        await batch.commit();
        batch = admin.firestore().batch();
        operationCount = 0;
      }
    }

    // Delete the allEventRef document
    const allEventRef = admin.firestore().collection('new_allEvents').doc(eventId);
    batch.delete(allEventRef);
    operationCount++;

    if (operationCount > 0) {
      await batch.commit();
    }

    // Delete the eventChatRooms document
     // eslint-disable-next-line no-await-in-loop
    await admin.firestore().collection('new_eventChatRooms').doc(eventId).delete();

    // Delete all documents in the ticketOrder subcollection
    const ticketOrderRef = admin.firestore().collection('new_eventTicketOrder').doc(eventId).collection('ticketOrders');
     // eslint-disable-next-line no-await-in-loop
    await deleteCollection(ticketOrderRef);

    // Delete all documents in the sentEventInvite subcollection
    const eventInviteRef = admin.firestore().collection('new_sentEventInvite').doc(eventId).collection('eventInvite');
     // eslint-disable-next-line no-await-in-loop
    await deleteCollection(eventInviteRef);

     // Delete all documents in the sentEventInvite subcollection
     const affiliateInviteRef = admin.firestore().collection('new_eventAffiliate').doc(eventId).collection('affiliateMarketers');
     // eslint-disable-next-line no-await-in-loop
    await deleteCollection(affiliateInviteRef);

    // Delete all documents in the asks subcollection
    const askRef = admin.firestore().collection('new_asks').doc(eventId).collection('eventAsks');
     // eslint-disable-next-line no-await-in-loop
    await deleteCollection(askRef);

    // Delete all documents in the roomChats subcollection
    const roomChatsRef = admin.firestore().collection('new_eventChatRoomsConversation').doc(eventId).collection('roomChats');
     // eslint-disable-next-line no-await-in-loop
    await deleteCollection(roomChatsRef);
  });




// Helper function to delete all documents in a collection or subcollection
async function deleteCollection(collectionRef) {
   // eslint-disable-next-line no-await-in-loop
  const snapshot = await collectionRef.get();

  if (snapshot.size === 0) {
    return;
  }

  let batch = admin.firestore().batch();
  let operationCount = 0;

  for (const doc of snapshot.docs) {
    batch.delete(doc.ref);
    operationCount++;

    if (operationCount >= 499) {
       // eslint-disable-next-line no-await-in-loop
      await batch.commit();
      batch = admin.firestore().batch();
      operationCount = 0;
    }
  }

  if (operationCount > 0) {
    await batch.commit();
  }
}


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
  const disableEventSuggestionNotification = doc.data().disableEventSuggestionNotification;
  const muteEventSuggestionNotification = doc.data().muteEventSuggestionNotification;

  let title;
  let body;
  

  if(androidNotificationToken){
  if(createdActivityItem.type  === 'newEventInNearYou' && disableEventSuggestionNotification ){

    console.log('disbled notification for event suggestion');
  
  }else{
    await sendNotification(androidNotificationToken, createdActivityItem, muteEventSuggestionNotification)
    }


  } else {
    console.log('no notification token');
  }

   async function sendNotification(androidNotificationToken, createdActivityItem, muteEventSuggestionNotification ) {
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
        case 'eventDeleted':
          title = createdActivityItem.authorName;
          break;
      case 'follow':
        title = createdActivityItem.authorName;
        break;
       
      default: 
        title = `${createdActivityItem.authorName}  [ ${createdActivityItem.type} ]`
    }
    body  = createdActivityItem.comment;


    let message = {
      notification: { body: body, title: title },
      data: {
        recipient: userId,
        contentType: createdActivityItem.type,
        authorId: createdActivityItem.authorId,
        contentId: createdActivityItem.postId,
        eventAuthorId: createdActivityItem.authorProfileHandle,
      },
      token: androidNotificationToken
  };

 
  // Set up a base APNS payload
let apnsPayload = {
  payload: {
      aps: {
          // This sound setting can be adjusted or customized as necessary
          sound: 'default',
      },
  },
};

// If the notification is of type 'newEventInNearYou' and is not muted, add the APNS payload
if (createdActivityItem.type === 'newEventInNearYou' && !muteEventSuggestionNotification) {
message.apns = apnsPayload;
} else if (createdActivityItem.type !== 'newEventInNearYou') {
// For all other notification types, always add the APNS payload
message.apns = apnsPayload;
}
 


    // const message = {notification: {body: body, title: title},
    //   data: {
        // recipient: userId,
        // contentType: createdActivityItem.type,
        // contentId: createdActivityItem.postId,
        // eventAuthorId: createdActivityItem.authorProfileHandle,
    //     // title: title,
    //     // body: body,
    //   },
    //   token: androidNotificationToken,
    
      // apns: {
      //   payload: {
      //     aps: {
      //       sound: 'default',
      //     },
      //   },
      // },
    // };
    
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

    const chatRoomUsersCollectionRef = admin.firestore().collection(`new_eventTicketOrder/${eventId}/ticketOrders`);
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


        const userTiketIdRef = admin.firestore().doc(`new_ticketId/${userId}/tickedIds/${eventId}`);
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
              contentId: String(eventId),
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

