
// void _submitForm(BuildContext context) async {
//     FirebaseFunctions functions = FirebaseFunctions.instance;
//     var createSubaccountCallable = functions.httpsCallable(
//       'createSubaccount',
//     );

//     var _user =
//         Provider.of<UserData>(context, listen: false).userLocationPreference;

//     if (_formKey.currentState!.validate() && !_isLoading) {
//       _formKey.currentState!.save();

//       if (mounted) {
//         setState(() {
//           _isLoading = true;
//         });
//       }

//       final bankCode = _selectedBankCode;

//       if (bankCode == null || bankCode.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Please select a bank'),
//         ));
//         return;
//       }

//       // Ensure you collect the percentage charge properly
//       final percentageCharge = 10; // Replace with your method/logic

//       final subaccountData = {
//         'business_name': _bussinessNameController.text.trim(),
//         'bank_code': bankCode,
//         'account_number': _accountNumber.text.trim(),
//         'percentage_charge': percentageCharge,
//         'currency': _user!.currency
//       };

//       // try {
//       final HttpsCallableResult<dynamic> result =
//           await createSubaccountCallable.call(
//         subaccountData,
//       );

//       // print('Full result data: ${result.data}');

//       var subaccountId = result.data['subaccount_id'];
//       var transferRecepient = result.data['recipient_code'];
//       print('Result data: $subaccountId');
//       //  print('Result data: $subaccountId');

//       if (subaccountId != null && _user != null) {
//         try {
//           await usersLocationSettingsRef.doc(_user.userId).update({
//             'subaccountId': subaccountId.toString(),
//             'transferRecepientId': transferRecepient.toString(),
//           });

//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content:
//                 Text('Subaccount created, continue with your event process.'),
//           ));
//           _updateAuthorHive(
//               subaccountId.toString(), transferRecepient.toString());
//         } catch (e) {
//           if (mounted) {
//             setState(() {
//               _isLoading = false;
//             });
//           }

//           // Log the error or use a debugger to inspect the error
//           // print('Error updating Firestore with subaccount ID: $e');
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Failed to update subaccount information'),
//           ));
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Received invalid subaccount data'),
//         ));
//       }
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//         // }
//       }

//       // on FirebaseFunctionsException catch (e) {
//       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       //     content: Text('Failed to create subaccount: ${e.message}'),
//       //   ));
//       //   if (mounted) {
//       //     setState(() {
//       //       _isLoading = false;
//       //     });
//       //   }
//       // } catch (e) {
//       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       //     content: Text('An unexpected error occurred'),
//       //   ));
//       //   if (mounted) {
//       //     setState(() {
//       //       _isLoading = false;
//       //     });
//       //   }
//       // } finally {
//       //   // Use finally to ensure _isLoading is set to false in both success and error scenarios
//       //   if (mounted) {
//       //     setState(() {
//       //       _isLoading = false;
//       //     });
//       //   }
//       // }
//     }
//   }




// // const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// const { Message } = require('firebase-functions/lib/providers/pubsub');
// admin.initializeApp();


// const {Storage} = require('@google-cloud/storage');

// const firestore = admin.firestore();
// const storage = new Storage();


// const functions = require('firebase-functions');
// const axios = require('axios');

// // Replace with your Paystack secret keya
// const PAYSTACK_SECRET_KEY = functions.config().paystack.secret;


// exports.scheduledRefundProcessor = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
//   console.log('Refund processor running');

//   const refundRequests = await db.collection('refundRequests').where('status', '==', 'pending').get();

//   if (refundRequests.empty) {
//     console.log('No pending refund requests to process.');
//     return null;
//   }

//   for (const refundRequest of refundRequests.docs) {
//     const refundData = refundRequest.data();
//     const transactionId = refundData.transactionId;
//     // ... Set up the payload and headers ...

//     try {
//       const response = await axios.post('https://api.paystack.co/refund', {
//         transaction: transactionId,
//         // Include amount if it's a partial refund
//       }, {
//         headers: {
//           'Authorization': `Bearer ${paystackSecretKey}`,
//           'Content-Type': 'application/json'
//         }
//       });

//       if (response.data.status) {
//         // Update the refund request status to 'processed'
//         await db.collection('refundRequests').doc(refundRequest.id).update({ status: 'processed' });
//         console.log(`Refund processed for transaction ID: ${transactionId}`);
//       } else {
//         console.log(`Failed to process refund for transaction ID: ${transactionId}`);
//       }
//     } catch (error) {
//       console.error('An error occurred during the refund process:', error);
//     }
//   }

//   return null;
// });









// exports.distributeEventFunds = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
//   // Fetch events that have ended but not yet had their funds distributed
  // const eventsSnapshot = await admin.firestore().collection('new_allEvents')
  //   .where('clossingDay', '<=', new Date())
  //   .where('fundsDistributed', '==', false)
  //   .get();

//   for (const eventDoc of eventsSnapshot.docs) {
//     const eventData = eventDoc.data();

//     // Check for pending refunds and process them before distribution
//     // ...

//     // Calculate the amount to distribute to the event organizer
//     const organizerShare = calculateOrganizerShare(eventData);

//     // Use Paystack API to transfer funds to the event organizer's subaccount
//     const response = await paystack.subaccount.createTransfer({
//       source: "balance", // Transfer from your Paystack balance
//       amount: organizerShare, // Amount to transfer in kobo
//       recipient: eventData.organizerSubaccountId, // The event organizer's subaccount ID
//     });

//     // Handle response and errors, then update the event as funds distributed
//     if (response.status) {
//       await eventDoc.ref.update({ fundsDistributed: true });
//     } else {
//       // Log error and potentially retry
//     }
//   }
// });



// async function calculateOrganizerShare(eventData) {
//   // Initialize a variable to hold the sum of all ticket totals
//   let totalAmountCollected = 0;

//   // Get a reference to the subcollection
//   const ticketOrderCollection = admin.firestore()
//     .collection('new_eventTicketOrder')
//     .doc(eventData.id)
//     .collection('eventInvite');

//   // Retrieve the snapshot
//   const totalTicketSnapshot = await ticketOrderCollection.get();

//   // Loop through each document in the snapshot
//   for (const eventDoc of totalTicketSnapshot.docs) {
//     // Accumulate the total amount from each ticket order
//     totalAmountCollected += eventDoc.data().total;
//   }

//   // Calculate your commission (10% of the total amount)
//   const commission = totalAmountCollected * 0.10;

//   // The organizer's share is the remaining 90%
//   const organizerShare = totalAmountCollected - commission;

//   // Return the organizer's share
//   return organizerShare;
// }




// exports.verifyPaystackPayment = functions.https.onCall(async (data, context) => {
//   // Ensure the user is authenticated
//   if (!context.auth) {
//     throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated to verify payment.');
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
//     if (paymentData.status === 'success' && paymentData.amount === expectedAmount) {
//       // Payment is successful and the amount matches
//       // You can proceed to grant the ticket or service in your database
//       // ...

//       return { success: true, message: 'Payment verified successfully' };
//     } else {
//       // Payment failed or the amount does not match
//       return { success: false, message: 'Payment verification failed' };
//     }
//   } catch (error) {
//     // Handle errors
//     console.error('Payment verification error:', error);
//     throw new functions.https.HttpsError('unknown', 'Payment verification failed', 'Please we couldn\t verify your payment, try purchasing the ticket again.');
//   }
// });



// exports.createSubaccount = functions.https.onCall(async (data, context) => {
//   if (!context.auth) {
//     throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
//   }

//   try {
//     const paystackResponse =  await axios.post('https://api.paystack.co/subaccount', {
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
//       return { subaccount_id: paystackResponse.data.data.subaccount_id };
//     } else {
//       throw new functions.https.HttpsError('unknown', 'Failed to create subaccount with Paystack');
//     }
//   } catch (error) {
//     console.error('Paystack subaccount creation error:', error);
//     throw new functions.https.HttpsError('unknown', 'Paystack subaccount creation failed', error);
//   }
// });


// // exports.deleteEmptyVideoUsers = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
// //   // Wait for 2 minutes
// //   await new Promise(resolve => setTimeout(resolve, 2 * 60 * 1000));

// //   // Loop through each user
// //   users.forEach(async (userDoc) => {
// //     const user = userDoc.data();

// //     // Check if professionalVideo1 field is empty
// //     if (!user.professionalVideo1) {
// //       const userId = userDoc.id;

// //       const collections = [
// //         { collection: 'forums', subCollection: 'userForums' },
// //         { collection: 'posts', subCollection: 'userPosts' },
// //         { collection: 'new_events', subCollection: 'userEvents' },
// //         { collection: 'following', subCollection: 'userFollowing' },
// //         { collection: 'followers', subCollection: 'userFollowers' },
// //         { collection: 'users', subCollection: 'chats' },
// //       ];
      
// //       // Delete Firestore data
// //       const deletions = collections.map(async (collection) => {
// //         try {
// //           const docs = await firestore.collection(collection.collection).doc(userId).collection(collection.subCollection).listDocuments();
// //           docs.forEach((doc) => doc.delete());
// //         } catch (error) {
// //           console.error(`Failed to delete Firestore data for user ${userId} in collection ${collection.collection}/${collection.subCollection}: `, error);
// //         }
// //       });
      
// //       // Delete Storage data
// //       const storagePaths = [
// //         `images/events/${userId}`,
// //         `images/messageImage/${userId}`,
// //         `images/users/${userId}`,
// //         `images/professionalPicture1/${userId}`,
// //         `images/professionalPicture2/${userId}`,
// //         `images/professionalPicture3/${userId}`,
// //         `images/validate/${userId}`,
// //       ];
      
// //       storagePaths.forEach(async (path) => {
// //         try {
// //           const files = await storage.bucket().getFiles({ prefix: path });
// //           files[0].forEach((file) => {
// //             file.delete();
// //           });
// //         } catch (error) {
// //           console.error(`Failed to delete Storage data for user ${userId} in path ${path}: `, error);
// //         }
// //       });

// //       // Delete user document
// //       try {
// //         await firestore.collection('users').doc(userId).delete();
// //         await firestore.collection('usersAuthors').doc(userId).delete();
// //       } catch (error) {
// //         console.error(`Failed to delete user document for user ${userId}: `, error);
// //       }
// //   // Remove user from follow lists
// //   await removeUserFromFollowLists(userId);

// //       // Delete user from Authentication
// //       try {
// //         await admin.auth().deleteUser(userId);
// //       } catch (error) {
// //         console.error(`Failed to delete user from Authentication for user ${userId}: `, error);
// //       }

// //       // Wait for all deletions to finish
// //       await Promise.all(deletions);
// //     }
// //   });
// // });


// async function removeUserFromFollowLists(userId) {
//   // Get all users
//   const usersSnapshot = await firestore.collection('users').get();

//   // Loop through each user
//   usersSnapshot.forEach(async (userDoc) => {
//     const otherUserId = userDoc.id;
//     const otherUser = userDoc.data();

//     // Check if this user is following the target user or is followed by the target user
//     const isFollowing = otherUser.following.includes(userId);
//     const isFollowed = otherUser.followers.includes(userId);

//     if (isFollowing || isFollowed) {
//       // Start a batch
//       let batch = firestore.batch();

//       if (isFollowing) {
//         // Remove the target user from the 'following' array
//         batch.update(userDoc.ref, {
//           following: admin.firestore.FieldValue.arrayRemove(userId)
//         });
//       }

//       if (isFollowed) {
//         // Remove the target user from the 'followers' array
//         batch.update(userDoc.ref, {
//           followers: admin.firestore.FieldValue.arrayRemove(userId)
//         });
//       }

//       // Commit the batch
//       await batch.commit();
//     }
//   });
// }


// async function removeUserFromBlockedList(userId) {
//   // Get all users
//   const usersSnapshot = await firestore.collection('users').get();

//   // Loop through each user
//   usersSnapshot.forEach(async (userDoc) => {
//     const otherUserId = userDoc.id;
//     const otherUser = userDoc.data();

//     // Check if this user is blocking the target user or is followed by the target user
//     const isBlocking = otherUser.usersBlocking.includes(userId);
//     const isBlocked = otherUser.usersBlocked.includes(userId);

//     if (isBlocking || isBlocked) {
//       // Start a batch
//       let batch = firestore.batch();

//       if (isBlocking) {
//         // Remove the target user from the 'usersBlocking' array
//         batch.update(userDoc.ref, {
//           usersBlocking: admin.firestore.FieldValue.arrayRemove(userId)
//         });
//       }

//       if (isBlocked) {
//         // Remove the target user from the 'usersBlocked' array
//         batch.update(userDoc.ref, {
//           usersBlocked: admin.firestore.FieldValue.arrayRemove(userId)
//         });
//       }

//       // Commit the batch
//       await batch.commit();
//     }
//   });
// }





// exports.deleteUserData = functions.auth.user().onDelete(async (user) => {
//   const userId = user.uid;

//   const collections = [
//     { collection: 'posts', subCollection: 'userPosts' },
//     { collection: 'new_events', subCollection: 'userEvents' },
//     { collection: 'following', subCollection: 'userFollowing' },
//     { collection: 'followers', subCollection: 'userFollowers' },
//     { collection: 'users', subCollection: 'chats' },
//     { collection: 'usersBlocked', subCollection: 'userBlocked' },
//     { collection: 'usersBlocking', subCollection: 'userBlocking' },

//   ];
  
//   // Delete Firestore data
//   const deletions = collections.map(async (collection) => {
//     const docs = await firestore.collection(collection.collection).doc(userId).collection(collection.subCollection).listDocuments();
//     docs.forEach((doc) => doc.delete());
//   });
  
//   // Delete Storage data
//   const storagePaths = [
//     `images/events/${userId}`,
//     `images/posts/${userId}`,
//     `images/messageImage/${userId}`,
//     `images/users/${userId}`,
//     `images/professionalPicture1/${userId}`,
//     `images/professionalPicture2/${userId}`,
//     `images/professionalPicture3/${userId}`,
//     `images/validate/${userId}`,
//   ];
  
//   storagePaths.forEach(async (path) => {
//     const files = await storage.bucket().getFiles({ prefix: path });
//     files[0].forEach((file) => {
//       file.delete();
//     });
//   });

//   // Remove user from follow lists
//   await removeUserFromFollowLists(userId);

//   // Remove user from block lists
//   await removeUserFromBlockedList(userId);

//   // Delete user document
//   firestore.collection('users').doc(userId).delete();
//   firestore.collection('usersAuthors').doc(userId).delete();

//   // Wait for all deletions to finish
//   await Promise.all(deletions);
// });








// exports.onFollowUser = functions.firestore
//   .document('/followers/{userId}/userFollowers/{followerId}')
//   .onCreate(async (snapshot, context) => {
//     console.log(snapshot.data());
//     const userId = context.params.userId;
//     const followerId = context.params.followerId;

//     // post+Feed/
//     const followedUserPostsRef = admin
//       .firestore()
//       .collection('posts')
//       .doc(userId)
//       .collection('userPosts');
//     const userFeedRef = admin
//       .firestore()
//       .collection('feeds')
//       .doc(followerId)
//       .collection('userFeed');
//     const followedUserPostsSnapshot = await followedUserPostsRef.get();
//     followedUserPostsSnapshot.forEach(doc => {
//       if (doc.exists) {
//         userFeedRef.doc(doc.id).set(doc.data());
//       }
//     });

//   //   // forum+ForumFeed
//   //   const followedUserForumsRef = admin
//   //   .firestore()
//   //   .collection('forums')
//   //   .doc(userId)
//   //   .collection('userForums');
//   // const userForumFeedRef = admin
//   //   .firestore()
//   //   .collection('forumFeeds')
//   //   .doc(followerId)
//   //   .collection('userForumFeed');
//   // const followedUserForumsSnapshot = await followedUserForumsRef.get();
//   // followedUserForumsSnapshot.forEach(doc => {
//   //   if (doc.exists) {
//   //     userForumFeedRef.doc(doc.id).set(doc.data());
//   //   }
//   // });

//    // event+EventFeed
//    const followedUserEventsRef = admin
//    .firestore()
//    .collection('new_eventFeeds')
//    .doc(userId)
//    .collection('userEvents');
//  const userEventFeedRef = admin
//    .firestore()
//    .collection('eventFeeds')
//    .doc(followerId)
//    .collection('userEventFeed');
//  const followedUserEventsSnapshot = await followedUserEventsRef.get();
//  followedUserEventsSnapshot.forEach(doc => {
//    if (doc.exists) {
//      userEventFeedRef.doc(doc.id).set(doc.data());
//    }
//  });


//   });




// exports.onUnfollowUser = functions.firestore
//   .document('/followers/{userId}/userFollowers/{followerId}')
//   .onDelete(async (snapshot, context) => {
//     const userId = context.params.userId;
//     const followerId = context.params.followerId;

//     // post+feed 
//     const userFeedRef = admin
//       .firestore()
//       .collection('feeds')
//       .doc(followerId)
//       .collection('userFeed')
//       .where('authorId', '==', userId);
//     const userPostsSnapshot = await userFeedRef.get();
//     userPostsSnapshot.forEach(doc => {
//       if (doc.exists) {
//         doc.ref.delete();
//       }
//     });

//   //  

//   // event+feed 
//   const userEventFeedRef = admin
//   .firestore()
//   .collection('new_eventFeeds')
//   .doc(followerId)
//   .collection('userEventFeed')
//   .where('authorId', '==', userId);
// const userEventsSnapshot = await userEventFeedRef.get();
// userEventsSnapshot.forEach(doc => {
//   if (doc.exists) {
//     doc.ref.delete();
//   }
// });

    
//   });

// // exports.onUploadPost = functions.firestore
// //   .document('/posts/{userId}/userPosts/{postId}')
// //   .onCreate(async (snapshot, context) => {
// //     console.log(snapshot.data());
// //     const userId = context.params.userId;
// //     const postId = context.params.postId;
// //     const userFollowersRef = admin
// //       .firestore()
// //       .collection('followers')
// //       .doc(userId)
// //       .collection('userFollowers');
// //     const userFollowersSnapshot = await userFollowersRef.get();
// //     userFollowersSnapshot.forEach(doc => {
// //       admin
// //         .firestore()
// //         .collection('feeds')
// //         .doc(doc.id)
// //         .collection('userFeed')
// //         .doc(postId)
// //         .set(snapshot.data());
// //     });
// //     // admin.firestore().collection('allPosts')
// //     // .doc(postId)
// //     // .set(snapshot.data());
// //   });


 

// //   exports.onDeleteFeedPost = functions.firestore
// //   .document('/posts/{userId}/userPosts/{postId}')
// // .onDelete(async (snapshot, context) => {
// //   const userId = context.params.userId;
// //   const postId = context.params.postId;
// //   console.log(snapshot.data());
// //   const userFollowersRef = admin
// //     .firestore()
// //     .collection('followers')
// //     .doc(userId)
// //     .collection('userFollowers');
// //   const userFollowersSnapshot = await userFollowersRef.get();
// //   userFollowersSnapshot.forEach(async userDoc => {
// //     const postRef = admin
// //       .firestore()
// //       .collection('feeds')
// //       .doc(userDoc.id)
// //       .collection('userFeed');
// //     const postDoc = await postRef.doc(postId).get();
// //     if (postDoc.exists) {
// //       postDoc.ref.delete();
// //     }
// //   })
// //   admin.firestore().collection('allPosts')
// //   .doc(postId).delete();
// // });


  
// // exports.onUploadForum = functions.firestore
// // .document('/forums/{userId}/userForums/{forumId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log(snapshot.data());
// //   const userId = context.params.userId;
// //   const forumId = context.params.forumId;
// //   const userFollowersRef = admin
// //     .firestore()
// //     .collection('followers')
// //     .doc(userId)
// //     .collection('userFollowers');
// //   const userFollowersSnapshot = await userFollowersRef.get();
// //   userFollowersSnapshot.forEach(doc => {
// //     admin
// //       .firestore()
// //       .collection('forumFeeds')
// //       .doc(doc.id)
// //       .collection('userForumFeed')
// //       .doc(forumId)
// //       .set(snapshot.data());
// //   });

// // });


// //   exports.onDeleteFeedForums = functions.firestore
// //   .document('/forums/{userId}/userForums/{forumId}')
// // .onDelete(async (snapshot, context) => {
// //   const userId = context.params.userId;
// //   const forumId = context.params.forumId;
// //   console.log(snapshot.data());
// //   const userFollowersRef = admin
// //     .firestore()
// //     .collection('followers')
// //     .doc(userId)
// //     .collection('userFollowers');
// //   const userFollowersSnapshot = await userFollowersRef.get();
// //   userFollowersSnapshot.forEach(async userDoc => {
// //     const forumRef = admin
// //       .firestore()
// //       .collection('forumFeeds')
// //       .doc(userDoc.id)
// //       .collection('userForumFeed')
// //     const forumDoc = await forumRef.doc(forumId).get();
// //     if (forumDoc.exists) {
// //       forumDoc.ref.delete();
// //     }
// //   })
// //   admin.firestore().collection('allForums')
// //   .doc(forumId).delete();
// // });


// // exports.onDeleteFeedThought = functions.firestore
// // .document('/thoughts/{forumId}/forumThoughts/{thoughtId}')
// // .onDelete(async (snapshot, context) => {
// // const forumId = context.params.forumId;
// // const thoughtId = context.params.thoughtId;
// // console.log(snapshot.data());
// // const thoghtsRef =  admin
// //     .firestore()
// //     .collection('replyThoughts')
// //     .doc(thoughtId)
// //     .collection('replyThoughts')
// //     const thoghtsSnapshot = await thoghtsRef.get();
// //     thoghtsSnapshot.forEach(async userDoc => {    
// //       if (userDoc.exists) {
// //         userDoc.ref.delete();
// //       }
// //     })
  

// // });

// exports.onUploadEvent = functions.firestore
//   .document('/new_events/{userId}/userEvents/{eventId}')
//   .onCreate(async (snapshot, context) => {
//     console.log(snapshot.data());
//     const userId = context.params.userId;
//     const eventId = context.params.eventId;
//     const userFollowersRef = admin
//       .firestore()
//       .collection('followers')
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
//       batch.set(eventFeedRef, snapshot.data());
//     });

//     // Commit the batch operation to update all follower documents
//     return batch.commit();
//   });

// exports.onDeleteFeedEvent = functions.firestore
//   .document('/new_events/{userId}/userEvents/{eventId}')
//   .onDelete(async (snapshot, context) => {
//     const userId = context.params.userId;
//     const eventId = context.params.eventId;
//     console.log(snapshot.data());
//     const userFollowersRef = admin
//       .firestore()
//       .collection('followers')
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
//     return admin.firestore().collection('allEvents').doc(eventId).delete();
//   });


//   exports.onUpdateEvent = functions.firestore
//   .document('/new_events/{userId}/userEvents/{eventId}')
//   .onUpdate(async (snapshot, context) => {
//     const userId = context.params.userId;
//     const eventId = context.params.eventId;
//     const newEventData = snapshot.after.data();
//     console.log(newEventData);

//     const userFollowersRef = admin
//       .firestore()
//       .collection('followers')
//       .doc(userId)
//       .collection('userFollowers');
//     const userFollowersSnapshot = await userFollowersRef.get();

//     const batch = admin.firestore().batch();

//     userFollowersSnapshot.forEach((userDoc) => {
//       const followerId = userDoc.id;
//       const eventRef = admin
//         .firestore()
//         .collection('new_eventFeeds')
//         .doc(followerId)
//         .collection('userEventFeed')
//         .doc(eventId);
//       batch.update(eventRef, newEventData);
//     });

//     // Commit the batch operation to update all follower documents
//     await batch.commit();

//     const allEventRef = admin.firestore().collection('new_allEvents').doc(eventId);
//     batch.update(allEventRef, newEventData);

//     // Commit the batch operation to update the event in 'new_allEvents' collection
//     await batch.commit();
//   });
  
// // exports.onUploadEvent = functions.firestore
// // .document('/events/{userId}/userEvents/{eventId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log(snapshot.data());
// //   const userId = context.params.userId;
// //   const eventId = context.params.eventId;
// //   const userFollowersRef = admin
// //     .firestore()
// //     .collection('followers')
// //     .doc(userId)
// //     .collection('userFollowers');
// //   const userFollowersSnapshot = await userFollowersRef.get();
// //   userFollowersSnapshot.forEach(doc => {
// //     admin
// //       .firestore()
// //       .collection('new_eventFeeds')
// //       .doc(doc.id)
// //       .collection('userEventFeed')
// //       .doc(eventId)
// //       .set(snapshot.data());
// //   });
 
// // });

// //   exports.onDeleteFeedEvent = functions.firestore
// //   .document('/events/{userId}/userEvents/{eventId}')
// // .onDelete(async (snapshot, context) => {
// //   const userId = context.params.userId;
// //   const eventId = context.params.eventId;
// //   console.log(snapshot.data());
// //   const userFollowersRef = admin
// //     .firestore()
// //     .collection('followers')
// //     .doc(userId)
// //     .collection('userFollowers');
// //   const userFollowersSnapshot = await userFollowersRef.get();
// //   userFollowersSnapshot.forEach(async userDoc => {
// //     const eventRef = admin
// //       .firestore()
// //       .collection('new_eventFeeds')
// //       .doc(userDoc.id)
// //       .collection('userEventFeed')
// //     const eventDoc = await eventRef.doc(eventId).get();
// //     if (eventDoc.exists) {
// //       eventDoc.ref.delete();
// //     }
// //   })
// //   admin.firestore().collection('allEvents')
// //   .doc(eventId).delete();
  
// // });

// // exports.onUpdatePost = functions.firestore
// // .document('/posts/{userId}/userPosts/{postId}')
// // .onUpdate(async (snapshot, context) => {
// //   const userId = context.params.userId;
// //   const postId = context.params.postId;
// //   const newPostData = snapshot.after.data();
// //   console.log(newPostData);
// //   const userFollowersRef = admin
// //     .firestore()
// //     .collection('followers')
// //     .doc(userId)
// //     .collection('userFollowers');
// //   const userFollowersSnapshot = await userFollowersRef.get();
// //   userFollowersSnapshot.forEach(async userDoc => {
// //     const postRef = admin
// //       .firestore()
// //       .collection('feeds')
// //       .doc(userDoc.id)
// //       .collection('userFeed');
// //     const postDoc = await postRef.doc(postId).get();
// //     if (postDoc.exists) {
// //       postDoc.ref.update(newPostData);
// //     }
// //   })

// //   const allPostsRef = admin
// //   .firestore()
// //   .collection('allPosts')
// //   const postDoc = await allPostsRef.doc(postId).get();
// //   if (postDoc.exists) {
// //     postDoc.ref.update(newPostData);
// //   }
// // });



// // exports.onUpdateForum = functions.firestore
// // .document('/forums/{userId}/userForums/{forumId}')
// // .onUpdate(async (snapshot, context) => {
// //   const userId = context.params.userId;
// //   const forumId = context.params.forumId;
// //   const newForumData = snapshot.after.data();
// //   console.log(newForumData);
// //   const userFollowersRef = admin
// //     .firestore()
// //     .collection('followers')
// //     .doc(userId)
// //     .collection('userFollowers');
// //   const userFollowersSnapshot = await userFollowersRef.get();
// //   userFollowersSnapshot.forEach(async userDoc => {
// //     const forumRef = admin
// //       .firestore()
// //       .collection('forumFeeds')
// //       .doc(userDoc.id)
// //       .collection('userForumFeed');
// //     const forumDoc = await forumRef.doc(forumId).get();
// //     if (forumDoc.exists) {
// //       forumDoc.ref.update(newForumData);
// //     }
// //   })

// //   const allForumsRef = admin
// //   .firestore()
// //   .collection('allForums')
// //   const forumDoc = await allForumsRef.doc(forumId).get();
// //   if (forumDoc.exists) {
// //     forumDoc.ref.update(newForumData);
// //   }
// // });

// // exports.onUpdateEvent = functions.firestore
// // .document('/events/{userId}/userEvents/{eventId}')
// // .onUpdate(async (snapshot, context) => {
// //   const userId = context.params.userId;
// //   const eventId = context.params.eventId;
// //   const newEventData = snapshot.after.data();
// //   console.log(newEventData);
// //   const userFollowersRef = admin
// //     .firestore()
// //     .collection('followers')
// //     .doc(userId)
// //     .collection('userFollowers');
// //   const userFollowersSnapshot = await userFollowersRef.get();
// //   userFollowersSnapshot.forEach(async userDoc => {
// //     const eventRef = admin
// //       .firestore()
// //       .collection('new_eventFeeds')
// //       .doc(userDoc.id)
// //       .collection('userEventFeed');
// //     const eventDoc = await eventRef.doc(eventId).get();
// //     if (eventDoc.exists) {
// //       eventDoc.ref.update(newEventData);
// //     }
// //   })
// //  const allEventRef = admin
// //   .firestore()
// //   .collection('new_allEvents')
// //   const eventDoc = await allEventRef.doc(eventId).get();
// //   if (eventDoc.exists) {
// //     eventDoc.ref.update(newEventData);
// //   }
  
// // });


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


// exports.onCreateNewActivity = functions.firestore
// .document('/new_activities/{userId}/userActivities/{userActivitiesId}')
// .onCreate(async (snapshot, context) => {
//   console.log('activity notification created', snapshot.data());
//   const userId = context.params.userId;
//   const createdActivityItem = snapshot.data();
//   const usersRef = admin.firestore().doc(`user_general_settings/${userId}`);
//   const doc = await usersRef.get();
//   const androidNotificationToken = doc.data().androidNotificationToken;
//   let title;
//   let body;

//   if(androidNotificationToken){
//     sendNotification(androidNotificationToken, createdActivityItem)
//   } else {
//     console.log('no notification token');
//   }

//    async function sendNotification(androidNotificationToken, createdActivityItem) {
//     switch (createdActivityItem.type){
//       case 'newEventInNearYou':
//         title = createdActivityItem.authorName;
//         break;
//       case 'inviteRecieved':
//         title = createdActivityItem.authorName;
//         break;
//       case 'ticketPurchased':
//         title = createdActivityItem.authorName;
//         break;
//       case 'follow':
//         title = createdActivityItem.authorName;
//         break;
       
//       default: 
//         title = `${createdActivityItem.authorName}  [ ${createdActivityItem.type} ]`
//     }
//     body  = createdActivityItem.comment;


//     const message = {notification: {body: body, title: title},
//       data: {
//         recipient: userId,
//         contentType: createdActivityItem.type,
//         contentId: createdActivityItem.postId,
//         // title: title,
//         // body: body,
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
    
//     // const message = {
//     //   notification: {body: body, title: title},
//     //   token: androidNotificationToken,
//     //   data: {recipient: userId,   contentType: createdActivityItem.type,    contentId: createdActivityItem.postId,   },
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





// // exports.onCreateActivityNotification = functions.firestore
// // .document('/activities/{userId}/userActivities/{userActivitiesId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log('activity notification created', snapshot.data());
// //   const userId = context.params.userId;
// //   const userActivitiesId = context.params.userActivitiesId;
// //   const createdActivityItem = snapshot.data();
// //   const usersRef = admin.firestore().doc(`users/${userId}`);
// //   const doc = await usersRef.get();
// //   const androidNotificationToken = doc.data().androidNotificationToken;
 
// //   if(androidNotificationToken){
// //    sendNotification(androidNotificationToken, createdActivityItem )
// //   } else {
// //     console.log('no notification token');
// //   }
// //   function sendNotification(androidNotificationToken, userActivities)
// //  {
// //    let body;
//   //  switch (userActivities.comment){
//   //   case null:
//   //     body = `[ ${userActivities.authorName} ] Dope`
//   //     break;
     
//   //     default: body = `[ ${userActivities.authorName} ] ${userActivities.comment} `
//   //  }
// //    let title;
// //    switch (userActivities.comment){
// //     case null:
// //       title = `New reaction`
// //       break;
     
// //       default: title = `New punch vibe `
// //    }
// //    const message = {
// //     notification: {body: body, title: title},
// //     token: androidNotificationToken,
// //     data: {recipient: userId},
// //    };
// //     admin
// //    .messaging()
// //    .send(message)
// //    .then(response => {
// //      return console.log('message sent', response);
// //    }).catch(error =>{
// //     console.log('error sending message', error);
// //    })
// //  }

// // });



// // exports.onCreateActivityEventNotification = functions.firestore
// // .document('/activitiesEvent/{userId}/userActivitiesEvent/{userActivitiesEventId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log('activity notification created', snapshot.data());
// //   const userId = context.params.userId;
// //   const userActivitiesEventId = context.params.userActivitiesEventId;
// //   const createdActivityItem = snapshot.data();
// //   const usersRef = admin.firestore().doc(`users/${userId}`);
// //   const doc = await usersRef.get();
// //   const androidNotificationToken = doc.data().androidNotificationToken;
 
// //   if(androidNotificationToken){
// //    sendNotification(androidNotificationToken, createdActivityItem )
// //   } else {
// //     console.log('no notification token');
// //   }
// //   function sendNotification(androidNotificationToken, userActivitiesEvent)
// //  {

// //     let body;
// //     switch (userActivitiesEvent.invited){
// //      case true:
// //        body = ` ${userActivitiesEvent.eventInviteType} `
// //        break;
      
// //        default: body = `[ ${userActivitiesEvent.authorName} ] ${userActivitiesEvent.ask} `
// //     }
// //     let title;
// //     switch (userActivitiesEvent.invited){
// //      case true:
// //        title = `New event invitation`
// //        break;
      
// //        default: title =  `New event question  `
// //     }
  
// //    const message = {
// //     notification: {body: body, title: title},
// //     token: androidNotificationToken,
// //     data: {recipient: userId},
// //    };
// //     admin
// //    .messaging()
// //    .send(message)
// //    .then(response => {
// //      return console.log('message sent', response);
// //    }).catch(error =>{
// //     console.log('error sending message', error);
// //    })
// //  }

// // });




// // exports.onCreateNewMessageActivity = functions.firestore
// // .document('/messages/{messageId}/conversation/{conversationId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log('activity notification created', snapshot.data());
// //   const createdActivityItem = snapshot.data();
// //     const userId = createdActivityItem.receiverId;

// //   const usersRef = admin.firestore().doc(`user_general_settings/${userId}`);
// //   const usersSendersRef = admin.firestore().doc(`user_author/${createdActivityItem.senderId}`);
// //   const sender = await usersSendersRef.get();

// //   const userCollectionRef = admin.firestore().collection(`user_author/${createdActivityItem.receiverId}/new_chats/${createdActivityItem.senderId}`);
// //   const userNotification = await userCollectionRef.get();
// //   const userNotificationMute = await userNotification.data().muteMessage;

// //   const doc = await usersRef.get();
// //   const androidNotificationToken = doc.data().androidNotificationToken;
// //   let title;
// //   let body;

// //   if(androidNotificationToken){
// //     sendNotification(androidNotificationToken, createdActivityItem,  userNotificationMute)
// //   } else {
// //     console.log('no notification token');
// //   }

// //    async function sendNotification(androidNotificationToken, createdActivityItem,  userNotificationMute) {
  
// //     title  =  `${sender.data().userName}  [ Message ]`;
// //     body  = createdActivityItem.content;


// //     let message = {
// //       notification: { body: body, title: title },
// //       data: {
// //           recipient: userId,
// //           contentType: 'message',
// //           contentId: createdActivityItem.senderId,
// //       },
// //       token: androidNotificationToken
// //   };

// //   // If notifications are not muted, add the APNS payload with default sound
// //   if (!userNotificationMute) {
// //       message.apns = {
// //           payload: {
// //               aps: {
// //                   sound: 'default', // Or specify your custom notification sound file
// //               },
// //           },
// //       };
// //   }

// //     // const message = {notification: {body: body, title: title},
// //     //   data: {
// //     //     recipient: userId,
// //     //     contentType: 'message',
// //     //     contentId: createdActivityItem.senderId,
     
// //     //   },
// //     //   token: androidNotificationToken,
// //     //   apns: {
// //     //     payload: {
// //     //       aps: {
// //     //         sound: 'default',
// //     //       },
// //     //     },
// //     //   },
// //     // };
    
// //     try {
// //        const response = await admin
// //          .messaging()
// //          .send(message);
// //        console.log('message sent', response);
// //      } catch (error) {
// //        console.log('error sending message', error);
// //        throw error;
// //      }
// //   }
// // });


// exports.onCreateNewMessageActivity = functions.firestore
//   .document('/messages/{messageId}/conversation/{conversationId}')
//   .onCreate(async (snapshot, context) => {
//     console.log('Activity notification created', snapshot.data());
//     const createdActivityItem = snapshot.data();
//     const userId = createdActivityItem.receiverId;

//     // Reference to the sender's settings in the receiver's chat subcollection
//     const userChatSettingsRef = admin.firestore()
//       .doc(`user_author/${createdActivityItem.receiverId}/new_chats/${createdActivityItem.senderId}`);
    
//     // Fetch the document that contains the muteMessage setting
//     const userChatSettingsDoc = await userChatSettingsRef.get();
//     // Check if the document exists and has the muteMessage field
//     const userNotificationMute = userChatSettingsDoc.exists ? userChatSettingsDoc.data().muteMessage : false;

//     const userSettingsRef = admin.firestore().doc(`user_general_settings/${userId}`);
//     const userSettingsDoc = await userSettingsRef.get();
//     const androidNotificationToken = userSettingsDoc.data().androidNotificationToken;

//     if (androidNotificationToken) {
//       try {
//         await sendNotification(androidNotificationToken, createdActivityItem, userNotificationMute);
//       } catch (error) {
//         console.error('Error sending notification:', error);
//       }
//     } else {
//       console.log('No notification token for user', userId);
//     }
//   });

// async function sendNotification(androidNotificationToken, activityItem, isMute) {
//   const senderRef = admin.firestore().doc(`user_author/${activityItem.senderId}`);
//   const senderDoc = await senderRef.get();
//   const title = `${senderDoc.data().userName} [ Message ]`;
//   const body = activityItem.content;

//   let message = {
//     notification: { body: body, title: title },
//     data: {
//         recipient: String(activityItem.receiverId),
//         contentType: 'message',
//         contentId: String(activityItem.senderId),
//     },
//     token: androidNotificationToken
//   };

//   // If notifications are not muted, add the APNS payload with the default sound
//   if (!isMute) {
//     message.apns = {
//       payload: {
//         aps: {
//           sound: 'default', // Or specify your custom notification sound file
//         },
//       },
//     };
//   }

//   const response = await admin.messaging().send(message);
//   console.log('Notification sent', response);
// }


// exports.onNewEventRoomMessage = functions.firestore
// .document('/new_eventChatRoomsConversation/{eventId}/roomChats/{chatId}')
// .onCreate(async (snapshot, context) => {
//     console.log('New chat message created', snapshot.data());
//     const newMessage = snapshot.data();
//     const eventId = context.params.eventId;
//     const usersSendersRef = admin.firestore().doc(`user_author/${newMessage.senderId}`);
//     const sender = await usersSendersRef.get();

//     const chatRoomUsersCollectionRef = admin.firestore().collection(`new_eventTicketOrder/${eventId}/eventInvite`);
//     const chatRoomUsersSnapshot = await chatRoomUsersCollectionRef.get();

//     if (chatRoomUsersSnapshot.empty) {
//         console.log('No users found for this ticket');
//         return;
//     }

//     const notifications = chatRoomUsersSnapshot.docs.map(async doc => {
//         const userId = doc.id;
//         if (userId === newMessage.senderId) {
//             return; // Skip the sender
//         }
//         const userRef = admin.firestore().doc(`user_general_settings/${userId}`);
//         const userDoc = await userRef.get();


//         const userTiketIdRef = admin.firestore().doc(`new_ticketId/${userId}/eventInvite/${eventId}`);
//         const userTicketIdDoc = await userTiketIdRef.get();
//         const userTicketNotificationMute = userTicketIdDoc.data().muteNotification;

//         const androidNotificationToken = userDoc.data().androidNotificationToken;

//         if (androidNotificationToken) {
//             return sendNotification(androidNotificationToken, newMessage, userId, userTicketNotificationMute  );
//         } else {
//             console.log(`No notification token for user ${userId}`);
//         }
//     });

//     return Promise.all(notifications);

//     async function sendNotification(androidNotificationToken, newMessage, userId, userTicketNotificationMute) {
//         const title = `${sender.data().userName} [ Event room ]`;
//         const body = newMessage.content;

//         let message = {
//           notification: { body: body, title: title },
//           data: {
//               recipient: String(userId),
//               contentType: 'eventRoom',
//               contentId: String(newMessage.senderId),
//           },
//           token: androidNotificationToken
//       };
  
//       // If notifications are not muted, add the APNS payload with default sound
//       if (!userTicketNotificationMute) {
//           message.apns = {
//               payload: {
//                   aps: {
//                       sound: 'default', // Or specify your custom notification sound file
//                   },
//               },
//           };
//       }

//         // const message = {
//         //     notification: {body: body, title: title},
//         //     data: {
//         //         recipient: String(userId),
//         //         contentType: 'eventRoom',
//         //         contentId: String(newMessage.senderId),
//         //     },
//         //     token: androidNotificationToken,
//         //     apns: {
//         //         payload: {
//         //             aps: {
//         //                 sound:userTicketNotificationMute == true? 'default' : '',
//         //             },
//         //         },
//         //     },
//         // };

//         try {
//             const response = await admin
//             .messaging()
//             .send(message);
//             console.log('message sent', response);
//         } catch (error) {
//             console.log('error sending message', error);
//             throw error;
//         }
//     }
// });



// // exports.onNewEventRoomMessage = functions.firestore
// // .document('/new_eventChatRoomsConversation/{ticketId}/roomChats/{chatId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log('New chat message created', snapshot.data());
// //   const newMessage = snapshot.data();
// //   const ticketId = context.params.ticketId;
// //   const usersSendersRef = admin.firestore().doc(`user_author/${newMessage.senderId}`);
// //   const sender = await usersSendersRef.get();


// //   const chatRoomUsersCollectionRef = admin.firestore().collection(`new_eventTicketOrder/${ticketId}/eventInvite`);
// // const chatRoomUsersSnapshot = await chatRoomUsersCollectionRef.get();

// // if (chatRoomUsersSnapshot.empty) {
// //   console.log('No users found for this ticket');
// //   return;
// // }

// // chatRoomUsersSnapshot.forEach(async doc => {
// //   const userId = doc.id; // assuming the document ID is the user ID
// //   const userRef = admin.firestore().doc(`user_general_settings/${userId}`);
// //   const userDoc = await userRef.get();
// //   const androidNotificationToken = userDoc.data().androidNotificationToken;

// //   if (androidNotificationToken) {
// //     await sendNotification(androidNotificationToken, newMessage, userId);
// //   } else {
// //     console.log(`No notification token for user ${userId}`);
// //   }
// // });

// //   async function sendNotification(androidNotificationToken, newMessage, userId) {
// //     const title = `${sender.data().userName} [ Event room ]`;
// //     const body = newMessage.content;

// //     const message = {
// //       notification: {body: body, title: title},
// //       data: {
// //         recipient: String(userId),
// //         contentType: 'eventRoom',
// //         contentId: String(newMessage.senderId),
// //       },
// //       token: androidNotificationToken,
// //       apns: {
// //         payload: {
// //           aps: {
// //             sound: 'default',
// //           },
// //         },
// //       },
// //     };

// //     try {
// //       const response = await admin
// //         .messaging()
// //         .send(message);
// //       console.log('message sent', response);
// //     } catch (error) {
// //       console.log('error sending message', error);
// //       throw error;
// //     }
// //   }
// // });



// // exports.onCreateChatMessage = functions.firestore
// // .document('/messages/{messageId}/conversation/{conversationId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log('activity notification created', snapshot.data());
// //   const userId = context.params.userId;
// //   const chatActivitiesId = context.params.chatActivitiesId;
// //   const createdActivityItem = snapshot.data();
// //   const usersRef = admin.firestore().doc(`users/${userId}`);
// //   const doc = await usersRef.get();
// //   const androidNotificationToken = doc.data().androidNotificationToken;
 
// //   if(androidNotificationToken){
// //    sendNotification(androidNotificationToken, createdActivityItem )
// //   } else {
// //     console.log('no notification token');
// //   }
// //   function sendNotification(androidNotificationToken, chatActivities)
// //  {

// //     let body;
// //     switch (chatActivities.liked){
// //      case true:
// //        body = `[ ${chatActivities.authorName}] like ${chatActivities.comment} `
// //        break;
      
// //        default: body = `[ ${chatActivities.authorName}] ${chatActivities.comment} `
// //     }
// //     let title;
// //     switch (chatActivities.liked){
// //      case false:
// //        title =  `Message Like  `
// //        break;
      
// //        default: title =  `New message  `
// //     }
  
// //    const message = {
// //     notification: {body: body, title: title},
// //     token: androidNotificationToken,
// //     data: {recipient: userId},
// //    };
// //     admin
// //    .messaging()
// //    .send(message)
// //    .then(response => {
// //      return console.log('message sent', response);
// //    }).catch(error =>{
// //     console.log('error sending message', error);
// //    })
// //  }

// // });


// // exports.onCreateActivityFollowerNotification = functions.firestore
// // .document('/activitiesFollower/{userId}/activitiesFollower/{activitiesFollowerId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log('activity notification created', snapshot.data());
// //   const userId = context.params.userId;
// //   const userActivitiesEventId = context.params.userActivitiesEventId;
// //   const createdActivityItem = snapshot.data();
// //   const usersRef = admin.firestore().doc(`users/${userId}`);
// //   const doc = await usersRef.get();
// //   const androidNotificationToken = doc.data().androidNotificationToken;


 
// //   if(androidNotificationToken){
// //    sendNotification(androidNotificationToken, createdActivityItem )
// //   } else {
// //     console.log('no notification token');
// //   }
// //   function sendNotification(androidNotificationToken, activitiesFollower )
// //  {
// //     body = ` ${activitiesFollower.authorName} `
// //     title = `New follower  `
  
// //    const message = {
// //     notification: {body: body, title: title},
// //     token: androidNotificationToken,
// //     data: {recipient: userId},
// //    };
// //     admin
// //    .messaging()
// //    .send(message)
// //    .then(response => {
// //      return console.log('message sent', response);
// //    }).catch(error =>{
// //     console.log('error sending message', error);
// //    })
// //  }

// // });




// // exports.onCreateActivityAdviceNotification = functions.firestore
// // .document('/activitiesAdvice/{userId}/userActivitiesAdvice/{userActivitiesAdviceId}')
// // .onCreate(async (snapshot, context) => {
// //   console.log('activity notification created', snapshot.data());
// //   const userId = context.params.userId;
// //   const userActivitiesAdviceId = context.params.userActivitiesAdviceId;
// //   const createdActivityItem = snapshot.data();
// //   const usersRef = admin.firestore().doc(`users/${userId}`);
// //   const doc = await usersRef.get();
// //   const androidNotificationToken = doc.data().androidNotificationToken;
 
// //   if(androidNotificationToken){
// //    sendNotification(androidNotificationToken, createdActivityItem )
// //   } else {
// //     console.log('no notification token');
// //   }
// //   function sendNotification(androidNotificationToken, userActivitiesAdvice)
// //  {
// //     body = `[ ${userActivitiesAdvice.authorName} ] ${userActivitiesAdvice.advice} `
// //     title = `New advice  `
  
// //    const message = {
// //     notification: {body: body, title: title},
// //     token: androidNotificationToken,
// //     data: {recipient: userId},
// //    };
// //     admin
// //    .messaging()
// //    .send(message)
// //    .then(response => {
// //      return console.log('message sent', response);
// //    }).catch(error =>{
// //     console.log('error sending message', error);
// //    })
// //  }

// // });
