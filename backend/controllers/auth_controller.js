const admin = require("firebase-admin");
const bcrypt = require('bcrypt');

//Password validation
const validatePassword = (password) => {
    return password.length >= 8 && /[A-Z]/.test(password) && /[0-9]/.test(password) && /[!@#$%^&*]/.test(password);
};

//validate session token
const validateSession = async (req, res) => {
    const authHeader = req.headers['authorization'];

    if (!authHeader) {
        return res.status(401).json({ message: 'No session token provided.' });
    }

    //Validate session
    req.sessionStore.get(authHeader, (err, session) => {
        if (err || !session) {
            return res.status(401).json({ message: 'Invalid session token.' });
        }

        return res.status(200).json({ message: 'Session is valid.' });
    });
};

//Manual SignUp
const manualSignUpWithEmailPassword = async (req, res) => {
    
    //Email validation regex
    const emailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;

    try{
    
        //Get user data
        const email  = req.body.email;
        const password = req.body.password;

        //Check required details
        if (!email || !password) {
            console.log("Missing email or password");
            return res.status(400).json({ error: 'Email and password are required' });
        }

        //Validate email
        if (!emailRegex.test(email)) {
            return res.status(400).json({ error: 'Invalid email format' });
        }

        //Validate password
        if (!validatePassword(password)) {
            return res.status(400).json({
                error: 'Password must be at least 8 characters long, contain one uppercase letter, one number, and one special character'
            });
        }

        //Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        //Create user
        const userRecord = await admin.auth().createUser({
            email: email,
            password: password
        });

        const userData = {
            email: email,
            password: hashedPassword, 
            sessionID: req.session.id,
            createdAt: admin.firestore.FieldValue.serverTimestamp()
        };

        //Store user in firestore
        await admin.firestore().collection('users').doc(userRecord.uid).set(userData);

        //Create session
        req.session.user = {
            uid: userRecord.uid,
            email: userRecord.email
        };

        //Send Response
        return res.status(200).json({
            message: "User signed up successfully",
            userId: userRecord.uid,
            email: userRecord.email,
            token: req.session.id,
        });

    } catch (error) {
        console.error('Error in Firebase Admin:', error);

        if (error.code === 'auth/email-already-exists') {
            return res.status(409).json({ error: 'The email address is already in use by another account.' });
        }
        if (error.code === 'auth/invalid-email') {
            return res.status(400).json({ error: 'The email address is invalid.' });
        }
        if (error.code === 'auth/weak-password') {
            return res.status(400).json({ error: 'The password is too weak.' });
        }

        return res.status(500).json({ error: 'Internal server error' });
    }
};

//Manual Login
const manualLoginWithEmailPassword = async (req, res) => {
    
    try{
    
        //Get user data
        const email  = req.body.email;
        const password = req.body.password;

        //Check required details
        if (!email || !password) {
            console.log("Missing email or password");
            return res.status(400).json({ error: 'Email and password are required' });
        }

        //Login user
        const userRecord = await admin.auth().getUserByEmail(email);

        if (!userRecord) {
            return res.status(404).json({ message: 'User not found' });
        }else{
            const userDoc = await admin.firestore().collection('users').doc(userRecord.uid).get();

            const userData = userDoc.data();

            //Check password
            const encryptedPassword = userData.password;

            const passwordMatch = await bcrypt.compare(password, encryptedPassword);

            if (!passwordMatch) {
                return res.status(401).json({ message: 'Invalid password' });
            }

            //Create session
            req.session.user = {
                uid: userRecord.uid,
                email: userRecord.email,
                sessionID: req.session.id,
            };

            //Store user in firestore
            await admin.firestore().collection('users').doc(userRecord.uid).update({
                sessionID : req.session.id
            });

            //Send Response
            return res.status(200).json({
                message: "Login Success",
                userId: userRecord.uid,
                email: userRecord.email,
                token: req.session.id
            });

        }

    } catch (error) {
        console.error('Error in Firebase Admin:', error);

        if (error.code === 'auth/user-not-found') {
            return res.status(409).json({ error: 'User not Found!' });
        }

        return res.status(500).json({ error: 'Internal server error' });
    }
};

//Sign In With Google
const signInWithGoogleOrFacebook = async (req, res) => {
    const email = req.body.email;
    const uID = req.body.uID;

    if (!email) {
        return res.status(400).json({ error: 'Email is required' });
    }

    try {

        const userData = {
            email: email,
            password: uID, 
            sessionID: req.session.id,
            createdAt: admin.firestore.FieldValue.serverTimestamp()
        };

        const userDoc = await admin.firestore().collection('users').doc(uID).get();

        if (!userDoc.exists) {
            await admin.firestore().collection('users').doc(uID).set(userData);
        } 

        //Create session
        req.session.user = {
            uid: uID,
            email: email
        };

        //Send Response
        return res.status(200).json({
            message: "Login Success",
            userId: uID,
            email: email,
            token: req.session.id,
        });
        
    } catch (error) {
        console.error('Error verifying Google or Facebook ID token:', error);
        return res.status(401).json({ error: 'Invalid ID token' });
    }
};

module.exports = { manualSignUpWithEmailPassword, signInWithGoogleOrFacebook, manualLoginWithEmailPassword, validateSession };