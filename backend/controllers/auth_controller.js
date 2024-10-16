const admin = require("firebase-admin");
const bcrypt = require('bcrypt');

// Password validation
const validatePassword = (password) => {
    return password.length >= 8 && /[A-Z]/.test(password) && /[0-9]/.test(password) && /[!@#$%^&*]/.test(password);
};

const manualSignUpWithEmailPassword = async (req, res) => {
    
    // Email validation regex
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

        // Validate email
        if (!emailRegex.test(email)) {
            return res.status(400).json({ error: 'Invalid email format' });
        }

        // Validate password
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
            createdAt: admin.firestore.FieldValue.serverTimestamp()
        };

        // Store user in firestore
        await admin.firestore().collection('users').doc(userRecord.uid).set(userData);

        const customToken = await admin.auth().createCustomToken(userRecord.uid);

        //Send Response
        return res.status(200).json({
            message: "User signed up successfully",
            userId: userRecord.uid,
            email: userRecord.email,
            token: customToken
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

module.exports = { manualSignUpWithEmailPassword };