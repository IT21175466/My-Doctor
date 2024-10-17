const express = require('express')
const app = express()
const bodyParser = require('body-parser');
const session = require('express-session');

const admin = require("firebase-admin");
const credentials = require("./serviceAccountKey.json");

//Controllers
const { manualSignUpWithEmailPassword, signInWithGoogle, manualLoginWithEmailPassword } = require('./controllers/auth_controller');
const { gettingLoggedUserData } = require('./controllers/user_info_controller');

admin.initializeApp({
    credential: admin.credential.cert(credentials)
});

app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(session({
    secret: '9f9c2db4e8b3d4f67e2f1c8e2d4c5a1b',
    resave: false,
    saveUninitialized: false,
    cookie: { maxAge: 60 * 60 * 1000 }
}));

//Routes
app.post('/api/auth/manualsignup', manualSignUpWithEmailPassword);

app.post('/api/auth/manuallogin', manualLoginWithEmailPassword);

app.post('/api/auth/signinwithgoogle', signInWithGoogle);

app.get('/api/user/userinfo', gettingLoggedUserData);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`Server is running on PORT ${PORT}.`);
});

