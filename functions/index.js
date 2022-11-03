const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Message } = require('firebase-functions/lib/providers/pubsub');
admin.initializeApp();


exports.onFollowUser = functions.firestore
  .document('/followers/{userId}/userFollowers/{followerId}')
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // post+Feed/
    const followedUserPostsRef = admin
      .firestore()
      .collection('posts')
      .doc(userId)
      .collection('userPosts');
    const userFeedRef = admin
      .firestore()
      .collection('feeds')
      .doc(followerId)
      .collection('userFeed');
    const followedUserPostsSnapshot = await followedUserPostsRef.get();
    followedUserPostsSnapshot.forEach(doc => {
      if (doc.exists) {
        userFeedRef.doc(doc.id).set(doc.data());
      }
    });

    // forum+ForumFeed
    const followedUserForumsRef = admin
    .firestore()
    .collection('forums')
    .doc(userId)
    .collection('userForums');
  const userForumFeedRef = admin
    .firestore()
    .collection('forumFeeds')
    .doc(followerId)
    .collection('userForumFeed');
  const followedUserForumsSnapshot = await followedUserForumsRef.get();
  followedUserForumsSnapshot.forEach(doc => {
    if (doc.exists) {
      userForumFeedRef.doc(doc.id).set(doc.data());
    }
  });

   // event+EventFeed
   const followedUserEventsRef = admin
   .firestore()
   .collection('events')
   .doc(userId)
   .collection('userEvents');
 const userEventFeedRef = admin
   .firestore()
   .collection('eventFeeds')
   .doc(followerId)
   .collection('userEventFeed');
 const followedUserEventsSnapshot = await followedUserEventsRef.get();
 followedUserEventsSnapshot.forEach(doc => {
   if (doc.exists) {
     userEventFeedRef.doc(doc.id).set(doc.data());
   }
 });

//  // blog+blogFeed
//  const followedUserBlogsRef = admin
//  .firestore()
//  .collection('blogs')
//  .doc(userId)
//  .collection('userBlogs');
// const userBlogFeedRef = admin
//  .firestore()
//  .collection('blogFeeds')
//  .doc(followerId)
//  .collection('userBlogFeed');
// const followedUserBlogsSnapshot = await followedUserBlogsRef.get();
// followedUserBlogsSnapshot.forEach(doc => {
//  if (doc.exists) {
//    userBlogFeedRef.doc(doc.id).set(doc.data());
//  }
// });

  });

exports.onUnfollowUser = functions.firestore
  .document('/followers/{userId}/userFollowers/{followerId}')
  .onDelete(async (snapshot, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // post+feed 
    const userFeedRef = admin
      .firestore()
      .collection('feeds')
      .doc(followerId)
      .collection('userFeed')
      .where('authorId', '==', userId);
    const userPostsSnapshot = await userFeedRef.get();
    userPostsSnapshot.forEach(doc => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });

    // fourm+feed 
    const userForumFeedRef = admin
    .firestore()
    .collection('forumFeeds')
    .doc(followerId)
    .collection('userForumFeed')
    .where('authorId', '==', userId);
  const userForumsSnapshot = await userForumFeedRef.get();
  userForumsSnapshot.forEach(doc => {
    if (doc.exists) {
      doc.ref.delete();
    }
  });

  // event+feed 
  const userEventFeedRef = admin
  .firestore()
  .collection('eventFeeds')
  .doc(followerId)
  .collection('userEventFeed')
  .where('authorId', '==', userId);
const userEventsSnapshot = await userEventFeedRef.get();
userEventsSnapshot.forEach(doc => {
  if (doc.exists) {
    doc.ref.delete();
  }
});

//  // blog+feed 
//  const userBlogFeedRef = admin
//  .firestore()
//  .collection('blogFeeds')
//  .doc(followerId)
//  .collection('userBlogFeed')
//  .where('authorId', '==', userId);
// const userBlogsSnapshot = await userBlogFeedRef.get();
// userBlogsSnapshot.forEach(doc => {
//  if (doc.exists) {
//    doc.ref.delete();
//  }
// });
    
  });

exports.onUploadPost = functions.firestore
  .document('/posts/{userId}/userPosts/{postId}')
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const postId = context.params.postId;
    const userFollowersRef = admin
      .firestore()
      .collection('followers')
      .doc(userId)
      .collection('userFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach(doc => {
      admin
        .firestore()
        .collection('feeds')
        .doc(doc.id)
        .collection('userFeed')
        .doc(postId)
        .set(snapshot.data());
    });
    // admin.firestore().collection('allPosts')
    // .doc(postId)
    // .set(snapshot.data());
  });


  // exports.allPosts = functions.firestore
  // .document('/posts/{userId}/userPosts/{postId}')
  // .onCreate(async (snapshot, context) => {
  //   console.log(snapshot.data());
  //   const userId = context.params.userId;
  //   const postId = context.params.postId;
  //   admin.firestore().collection('allPosts')
  //   .doc(postId)
  //   .set(snapshot.data());
  
  // })

  // exports.deleteAllPosts = functions.firestore
  // .document('/posts/{userId}/userPosts/{postId}')
  // .onDelete(async (snapshot, context) => {
  //   console.log(snapshot.data());
  //   const userId = context.params.userId;
  //   const postId = context.params.postId;
  //   admin.firestore().collection('allPosts')
  //   .doc(postId).delete();
  // })

  exports.onDeleteFeedPost = functions.firestore
  .document('/posts/{userId}/userPosts/{postId}')
.onDelete(async (snapshot, context) => {
  const userId = context.params.userId;
  const postId = context.params.postId;
  console.log(snapshot.data());
  const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
  const userFollowersSnapshot = await userFollowersRef.get();
  userFollowersSnapshot.forEach(async userDoc => {
    const postRef = admin
      .firestore()
      .collection('feeds')
      .doc(userDoc.id)
      .collection('userFeed');
    const postDoc = await postRef.doc(postId).get();
    if (postDoc.exists) {
      postDoc.ref.delete();
    }
  })
  admin.firestore().collection('allPosts')
  .doc(postId).delete();
});


  
exports.onUploadForum = functions.firestore
.document('/forums/{userId}/userForums/{forumId}')
.onCreate(async (snapshot, context) => {
  console.log(snapshot.data());
  const userId = context.params.userId;
  const forumId = context.params.forumId;
  const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
  const userFollowersSnapshot = await userFollowersRef.get();
  userFollowersSnapshot.forEach(doc => {
    admin
      .firestore()
      .collection('forumFeeds')
      .doc(doc.id)
      .collection('userForumFeed')
      .doc(forumId)
      .set(snapshot.data());
  });
  // admin.firestore().collection('allForums')
  // .doc(forumId)
  // .set(snapshot.data());
});

// exports.allForums = functions.firestore
// .document('/forums/{userId}/userForums/{forumId}')
// .onCreate(async (snapshot, context) => {
//   console.log(snapshot.data());
//   const userId = context.params.userId;
//   const forumId = context.params.forumId;
//   admin.firestore().collection('allForums')
//   .doc(forumId)
//   .set(snapshot.data());

// })

// exports.deleteAllForums = functions.firestore
// .document('/forums/{userId}/userForums/{forumId}')
//   .onDelete(async (snapshot, context) => {
//     console.log(snapshot.data());
//     const userId = context.params.userId;
//     const forumId = context.params.forumId;
//     admin.firestore().collection('allForums')
//     .doc(forumId).delete();
//   })

// exports.deleteUserForums = functions.firestore
// .document('/forums/{userId}/userForums/{forumId}')
//   .onDelete(async (snapshot, context) => {
//     console.log(snapshot.data());
//     const userId = context.params.userId;
//     const forumId = context.params.forumId;
//     admin.firestore().collection('allForums')
//     .doc(forumId).delete();
//   })


  exports.onDeleteFeedForums = functions.firestore
  .document('/forums/{userId}/userForums/{forumId}')
.onDelete(async (snapshot, context) => {
  const userId = context.params.userId;
  const forumId = context.params.forumId;
  console.log(snapshot.data());
  const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
  const userFollowersSnapshot = await userFollowersRef.get();
  userFollowersSnapshot.forEach(async userDoc => {
    const forumRef = admin
      .firestore()
      .collection('forumFeeds')
      .doc(userDoc.id)
      .collection('userForumFeed')
    const forumDoc = await forumRef.doc(forumId).get();
    if (forumDoc.exists) {
      forumDoc.ref.delete();
    }
  })
  admin.firestore().collection('allForums')
  .doc(forumId).delete();
});


exports.onDeleteFeedThought = functions.firestore
.document('/thoughts/{forumId}/forumThoughts/{thoughtId}')
.onDelete(async (snapshot, context) => {
const forumId = context.params.forumId;
const thoughtId = context.params.thoughtId;
console.log(snapshot.data());
const thoghtsRef =  admin
    .firestore()
    .collection('replyThoughts')
    .doc(thoughtId)
    .collection('replyThoughts')
    const thoghtsSnapshot = await thoghtsRef.get();
    thoghtsSnapshot.forEach(async userDoc => {    
      if (userDoc.exists) {
        userDoc.ref.delete();
      }
    })
  

});



// exports.onUploadBlog = functions.firestore
// .document('/blogs/{userId}/userBlogs/{blogId}')
// .onCreate(async (snapshot, context) => {
//   console.log(snapshot.data());
//   const userId = context.params.userId;
//   const blogId = context.params.blogId;
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(doc => {
//     admin
//       .firestore()
//       .collection('blogFeeds')
//       .doc(doc.id)
//       .collection('userBlogFeed')
//       .doc(blogId)
//       .set(snapshot.data());
//   });
// });

// exports.allBlogs = functions.firestore
// .document('/blogs/{userId}/userBlogs/{blogId}')
// .onCreate(async (snapshot, context) => {
//   console.log(snapshot.data());
//   const userId = context.params.userId;
//   const blogId = context.params.blogId;
//   admin.firestore().collection('allBlogs')
//   .doc(blogId)
//   .set(snapshot.data());

// })

// exports.deleteAllBlogs = functions.firestore
// .document('/blogs/{userId}/userBlogs/{blogId}')
//   .onDelete(async (snapshot, context) => {
//     console.log(snapshot.data());
//     const userId = context.params.userId;
//     const blogId = context.params.blogId;
//     admin.firestore().collection('allBlogs')
//     .doc(blogId).delete();
//   })

//   exports.onDeleteFeedBlogss = functions.firestore
//   .document('/blogs/{userId}/userBlogs/{blogId}')
// .onDelete(async (snapshot, context) => {
//   const userId = context.params.userId;
//   const blogId = context.params.blogId;
//   console.log(snapshot.data());
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(async userDoc => {
//     const blogRef = admin
//       .firestore()
//       .collection('blogFeeds')
//       .doc(userDoc.id)
//       .collection('userBlogFeed')
//     const blogDoc = await blogRef.doc(blogId).get();
//     if (blogDoc.exists) {
//       blogDoc.ref.delete();
//     }
//   })
// });


  
exports.onUploadEvent = functions.firestore
.document('/events/{userId}/userEvents/{eventId}')
.onCreate(async (snapshot, context) => {
  console.log(snapshot.data());
  const userId = context.params.userId;
  const eventId = context.params.eventId;
  const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
  const userFollowersSnapshot = await userFollowersRef.get();
  userFollowersSnapshot.forEach(doc => {
    admin
      .firestore()
      .collection('eventFeeds')
      .doc(doc.id)
      .collection('userEventFeed')
      .doc(eventId)
      .set(snapshot.data());
  });
  // admin.firestore().collection('allEvents')
  // .doc(eventId)
  // .set(snapshot.data());
});

// exports.allEvents = functions.firestore
// .document('/events/{userId}/userEvents/{eventId}')
// .onCreate(async (snapshot, context) => {
//   console.log(snapshot.data());
//   const userId = context.params.userId;
//   const eventId = context.params.eventId;
//   admin.firestore().collection('allEvents')
//   .doc(eventId)
//   .set(snapshot.data());

// })

// exports.deleteAllEvents = functions.firestore
// .document('/events/{userId}/userEvents/{eventId}')
//   .onDelete(async (snapshot, context) => {
//     console.log(snapshot.data());
//     const userId = context.params.userId;
//     const eventId = context.params.eventId;
//     admin.firestore().collection('allEvents')
//     .doc(eventId).delete();
//   })

  exports.onDeleteFeedEvent = functions.firestore
  .document('/events/{userId}/userEvents/{eventId}')
.onDelete(async (snapshot, context) => {
  const userId = context.params.userId;
  const eventId = context.params.eventId;
  console.log(snapshot.data());
  const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
  const userFollowersSnapshot = await userFollowersRef.get();
  userFollowersSnapshot.forEach(async userDoc => {
    const eventRef = admin
      .firestore()
      .collection('eventFeeds')
      .doc(userDoc.id)
      .collection('userEventFeed')
    const eventDoc = await eventRef.doc(eventId).get();
    if (eventDoc.exists) {
      eventDoc.ref.delete();
    }
  })
  admin.firestore().collection('allEvents')
  .doc(eventId).delete();
  
});

exports.onUpdatePost = functions.firestore
.document('/posts/{userId}/userPosts/{postId}')
.onUpdate(async (snapshot, context) => {
  const userId = context.params.userId;
  const postId = context.params.postId;
  const newPostData = snapshot.after.data();
  console.log(newPostData);
  const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
  const userFollowersSnapshot = await userFollowersRef.get();
  userFollowersSnapshot.forEach(async userDoc => {
    const postRef = admin
      .firestore()
      .collection('feeds')
      .doc(userDoc.id)
      .collection('userFeed');
    const postDoc = await postRef.doc(postId).get();
    if (postDoc.exists) {
      postDoc.ref.update(newPostData);
    }
  })

  const allPostsRef = admin
  .firestore()
  .collection('allPosts')
  const postDoc = await allPostsRef.doc(postId).get();
  if (postDoc.exists) {
    postDoc.ref.update(newPostData);
  }
});



// exports.onUpdateBlog = functions.firestore
// .document('/blogs/{userId}/userBlogs/{blogId}')
// .onUpdate(async (snapshot, context) => {
//   const userId = context.params.userId;
//   const blogId = context.params.blogId;
//   const newBlogData = snapshot.after.data();
//   console.log(newBlogData);
//   const userFollowersRef = admin
//     .firestore()
//     .collection('followers')
//     .doc(userId)
//     .collection('userFollowers');
//   const userFollowersSnapshot = await userFollowersRef.get();
//   userFollowersSnapshot.forEach(async userDoc => {
//     const blogRef = admin
//     .firestore()
//     .collection('blogFeeds')
//     .doc(userDoc.id)
//     .collection('userBlogFeed')
//     const blogDoc = await blogRef.doc(blogId).get();
//     if (blogDoc.exists) {
//       blogDoc.ref.update(newBlogData);
//     }
//   })
  

//   const allBlogsRef = admin
//   .firestore()
//   .collection('allBlogs')
//   const blogDoc = await allBlogsRef.doc(blogId).get();
//   if (blogDoc.exists) {
//     blogDoc.ref.update(newBlogData);
//   }
// });

exports.onUpdateForum = functions.firestore
.document('/forums/{userId}/userForums/{forumId}')
.onUpdate(async (snapshot, context) => {
  const userId = context.params.userId;
  const forumId = context.params.forumId;
  const newForumData = snapshot.after.data();
  console.log(newForumData);
  const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
  const userFollowersSnapshot = await userFollowersRef.get();
  userFollowersSnapshot.forEach(async userDoc => {
    const forumRef = admin
      .firestore()
      .collection('forumFeeds')
      .doc(userDoc.id)
      .collection('userForumFeed');
    const forumDoc = await forumRef.doc(forumId).get();
    if (forumDoc.exists) {
      forumDoc.ref.update(newForumData);
    }
  })

  const allForumsRef = admin
  .firestore()
  .collection('allForums')
  const forumDoc = await allForumsRef.doc(forumId).get();
  if (forumDoc.exists) {
    forumDoc.ref.update(newForumData);
  }
});

exports.onUpdateEvent = functions.firestore
.document('/events/{userId}/userEvents/{eventId}')
.onUpdate(async (snapshot, context) => {
  const userId = context.params.userId;
  const eventId = context.params.eventId;
  const newEventData = snapshot.after.data();
  console.log(newEventData);
  const userFollowersRef = admin
    .firestore()
    .collection('followers')
    .doc(userId)
    .collection('userFollowers');
  const userFollowersSnapshot = await userFollowersRef.get();
  userFollowersSnapshot.forEach(async userDoc => {
    const eventRef = admin
      .firestore()
      .collection('eventFeeds')
      .doc(userDoc.id)
      .collection('userEventFeed');
    const eventDoc = await eventRef.doc(eventId).get();
    if (eventDoc.exists) {
      eventDoc.ref.update(newEventData);
    }
  })
 const allEventRef = admin
  .firestore()
  .collection('allEvents')
  const eventDoc = await allEventRef.doc(eventId).get();
  if (eventDoc.exists) {
    eventDoc.ref.update(newEventData);
  }
  
});


exports.onCreateActivityNotification = functions.firestore
.document('/activities/{userId}/userActivities/{userActivitiesId}')
.onCreate(async (snapshot, context) => {
  console.log('activity notification created', snapshot.data());
  const userId = context.params.userId;
  const userActivitiesId = context.params.userActivitiesId;
  const createdActivityItem = snapshot.data();
  const usersRef = admin.firestore().doc(`users/${userId}`);
  const doc = await usersRef.get();
  const androidNotificationToken = doc.data().androidNotificationToken;
 
  if(androidNotificationToken){
   sendNotification(androidNotificationToken, createdActivityItem )
  } else {
    console.log('no notification token');
  }
  function sendNotification(androidNotificationToken, userActivities)
 {
   let body;
   switch (userActivities.comment){
    case null:
      body = `[ ${userActivities.authorName} ] Dope`
      break;
     
      default: body = `[ ${userActivities.authorName} ] ${userActivities.comment} `
   }
   let title;
   switch (userActivities.comment){
    case null:
      title = `New reaction`
      break;
     
      default: title = `New punch vibe `
   }
   const message = {
    notification: {body: body, title: title},
    token: androidNotificationToken,
    data: {recipient: userId},
   };
    admin
   .messaging()
   .send(message)
   .then(response => {
     return console.log('message sent', response);
   }).catch(error =>{
    console.log('error sending message', error);
   })
 }

});



exports.onCreateActivityForumNotification = functions.firestore
.document('/activitiesForum/{userId}/userActivitiesForum/{userActivitiesForumId}')
.onCreate(async (snapshot, context) => {
  console.log('activity notification created', snapshot.data());
  const userId = context.params.userId;
  const userActivitiesForumId = context.params.userActivitiesForumId;
  const createdActivityItem = snapshot.data();
  const usersRef = admin.firestore().doc(`users/${userId}`);
  const doc = await usersRef.get();
  const androidNotificationToken = doc.data().androidNotificationToken;
 
  if(androidNotificationToken){
   sendNotification(androidNotificationToken, createdActivityItem )
  } else {
    console.log('no notification token');
  }
  function sendNotification(androidNotificationToken, userActivitiesForum)
 {
    body = `[ ${userActivitiesForum.authorName} ] ${userActivitiesForum.thought} `
    title = `New forum thought `
  
   const message = {
    notification: {body: body, title: title},
    token: androidNotificationToken,
    data: {recipient: userId},
   };
    admin
   .messaging()
   .send(message)
   .then(response => {
     return console.log('message sent', response);
   }).catch(error =>{
    console.log('error sending message', error);
   })
 }

});


exports.onCreateActivityEventNotification = functions.firestore
.document('/activitiesEvent/{userId}/userActivitiesEvent/{userActivitiesEventId}')
.onCreate(async (snapshot, context) => {
  console.log('activity notification created', snapshot.data());
  const userId = context.params.userId;
  const userActivitiesEventId = context.params.userActivitiesEventId;
  const createdActivityItem = snapshot.data();
  const usersRef = admin.firestore().doc(`users/${userId}`);
  const doc = await usersRef.get();
  const androidNotificationToken = doc.data().androidNotificationToken;
 
  if(androidNotificationToken){
   sendNotification(androidNotificationToken, createdActivityItem )
  } else {
    console.log('no notification token');
  }
  function sendNotification(androidNotificationToken, userActivitiesEvent)
 {
    // body = ` ${userActivitiesEvent.ask} `
    // title = `New event question  `
    let body;
    switch (userActivitiesEvent.ask){
     case null:
       body = ` ${userActivitiesEvent.eventInviteType} `
       break;
      
       default: body = `[ ${userActivitiesEvent.authorName} ] ${userActivitiesEvent.ask} `
    }
    let title;
    switch (userActivitiesEvent.ask){
     case null:
       title = `New event invitation`
       break;
      
       default: title =  `New event question  `
    }
  
   const message = {
    notification: {body: body, title: title},
    token: androidNotificationToken,
    data: {recipient: userId},
   };
    admin
   .messaging()
   .send(message)
   .then(response => {
     return console.log('message sent', response);
   }).catch(error =>{
    console.log('error sending message', error);
   })
 }

});




exports.onCreateChatMessage = functions.firestore
.document('/activitiesChat/{userId}/chatActivities/{chatActivitiesId}')
.onCreate(async (snapshot, context) => {
  console.log('activity notification created', snapshot.data());
  const userId = context.params.userId;
  const chatActivitiesId = context.params.chatActivitiesId;
  const createdActivityItem = snapshot.data();
  const usersRef = admin.firestore().doc(`users/${userId}`);
  const doc = await usersRef.get();
  const androidNotificationToken = doc.data().androidNotificationToken;
 
  if(androidNotificationToken){
   sendNotification(androidNotificationToken, createdActivityItem )
  } else {
    console.log('no notification token');
  }
  function sendNotification(androidNotificationToken, chatActivities)
 {
    body = `[ ${chatActivities.authorName}] ${chatActivities.comment} `
    title = `New message  `
  
   const message = {
    notification: {body: body, title: title},
    token: androidNotificationToken,
    data: {recipient: userId},
   };
    admin
   .messaging()
   .send(message)
   .then(response => {
     return console.log('message sent', response);
   }).catch(error =>{
    console.log('error sending message', error);
   })
 }

});


exports.onCreateActivityFollowerNotification = functions.firestore
.document('/activitiesFollower/{userId}/activitiesFollower/{activitiesFollowerId}')
.onCreate(async (snapshot, context) => {
  console.log('activity notification created', snapshot.data());
  const userId = context.params.userId;
  const userActivitiesEventId = context.params.userActivitiesEventId;
  const createdActivityItem = snapshot.data();
  const usersRef = admin.firestore().doc(`users/${userId}`);
  const doc = await usersRef.get();
  const androidNotificationToken = doc.data().androidNotificationToken;

  const userRef = admin.firestore().doc(`users/${createdActivityItem.fromUserId}`);
  const docs = await userRef.get();
  const followerName = docs.data().userName;
 
  if(androidNotificationToken){
   sendNotification(androidNotificationToken, createdActivityItem )
  } else {
    console.log('no notification token');
  }
  function sendNotification(androidNotificationToken, activitiesFollower )
 {
    body = ` ${followerName} `
    title = `New follower  `
  
   const message = {
    notification: {body: body, title: title},
    token: androidNotificationToken,
    data: {recipient: userId},
   };
    admin
   .messaging()
   .send(message)
   .then(response => {
     return console.log('message sent', response);
   }).catch(error =>{
    console.log('error sending message', error);
   })
 }

});




exports.onCreateActivityAdviceNotification = functions.firestore
.document('/activitiesAdvice/{userId}/userActivitiesAdvice/{userActivitiesAdviceId}')
.onCreate(async (snapshot, context) => {
  console.log('activity notification created', snapshot.data());
  const userId = context.params.userId;
  const userActivitiesAdviceId = context.params.userActivitiesAdviceId;
  const createdActivityItem = snapshot.data();
  const usersRef = admin.firestore().doc(`users/${userId}`);
  const doc = await usersRef.get();
  const androidNotificationToken = doc.data().androidNotificationToken;
 
  if(androidNotificationToken){
   sendNotification(androidNotificationToken, createdActivityItem )
  } else {
    console.log('no notification token');
  }
  function sendNotification(androidNotificationToken, userActivitiesAdvice)
 {
    body = `[ ${userActivitiesAdvice.authorName} ] ${userActivitiesAdvice.advice} `
    title = `New advice  `
  
   const message = {
    notification: {body: body, title: title},
    token: androidNotificationToken,
    data: {recipient: userId},
   };
    admin
   .messaging()
   .send(message)
   .then(response => {
     return console.log('message sent', response);
   }).catch(error =>{
    console.log('error sending message', error);
   })
 }

});

