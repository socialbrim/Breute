'use-strict'

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.sendNotificationforComments = functions.database.ref('Social Media Data/{customer_id}/{postID}/comments/{commentpersonID}').onCreate((change, context) => {
    const customerID = context.params.customer_id;
    const commenterID = context.params.commentpersonID;
    const postid = context.params.postID;


    return admin.database().ref("Social Media Data/" + customerID + postid).once('value').then((snapshot) => {

        const from_data = admin.database().ref('User Information/' + commenterID).once('value');

        const to_data = admin.database().ref('User Information/' + customerID).once('value');


        return Promise.all([from_data, to_data]).then(result => {

            const to_name = result[1].val().userName;
            const token_id = result[1].val().fcmtoken;
            const from_name = result[0].val().userName;

            const payload = {
                notification: {
                    title: "1 new comment",
                    body: from_name + " give a comment on your post",
                    icon: "default",
                    sound: "default",
                    onclick: "FLUTTER_NOTIFICATION_CLICK"
                }
            };

            return admin.messaging().sendToDevice(token_id, payload).then(result => {
                return true;
            });
        });
    });
});


exports.sendNotificationforLike = functions.database.ref('Social Media Data/{customer_id}/{postID}/likeIDs/{commentpersonID}').onCreate((change, context) => {
    const customerID = context.params.customer_id;
    const commenterID = context.params.commentpersonID;
    const postid = context.params.postID;


    return admin.database().ref("Social Media Data/" + customerID + postid).once('value').then((snapshot) => {

        const from_data = admin.database().ref('User Information/' + commenterID).once('value');

        const to_data = admin.database().ref('User Information/' + customerID).once('value');


        return Promise.all([from_data, to_data]).then(result => {

            const to_name = result[1].val().userName;
            const token_id = result[1].val().fcmtoken;
            const from_name = result[0].val().userName;

            const payload = {
                notification: {
                    title: "1 new Like!",
                    body: from_name + " Like Your post",
                    icon: "default",
                    sound: "default",
                    onclick: "FLUTTER_NOTIFICATION_CLICK"
                }
            };

            return admin.messaging().sendToDevice(token_id, payload).then(result => {
                return true;
            });
        });
    });
});