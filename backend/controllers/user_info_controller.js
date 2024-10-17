const admin = require("firebase-admin");

const gettingLoggedUserData = async (req, res) => {
    const authHeader = req.headers['authorization'];

    if (!authHeader) {
        return res.status(401).json({ error: 'No session ID provided.' });
    }

    try {
        const session = await new Promise((resolve, reject) => {
            req.sessionStore.get(authHeader, (err, session) => {
                if (err || !session) {
                    reject(new Error('Invalid session ID.'));
                } else {
                    resolve(session);
                }
            });
        });

        const uid = session.user?.uid;

        if (!uid) {
            return res.status(404).json({ error: 'User not found in session.' });
        }

        //Fetch user data from Firestore
        const userDoc = await admin.firestore().collection('users').doc(uid).get();

        if (!userDoc.exists) {
            return res.status(404).json({ error: 'User not found in Firestore.' });
        }

        const userData = userDoc.data();
        const email = userData.email;

        //Send the response
        return res.status(200).json({
            email: email,
        });

    } catch (error) {
        console.error('Error getting user from Firestore:', error.message);
        return res.status(500).json({ error: error.message });
    }
};

module.exports = { gettingLoggedUserData };
