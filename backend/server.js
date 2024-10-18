const express = require('express')
const app = express()
const bodyParser = require('body-parser');
const session = require('express-session');
require('dotenv').config();

const admin = require("firebase-admin");

const credentials = {
    "type": "service_account",
    "project_id": "mydoctor-6b681",
    "private_key_id": process.env.PRIVATE_KEY_ID,
    "private_key": process.env.PRIVATE_KEY,
    "client_email": "firebase-adminsdk-bm2au@mydoctor-6b681.iam.gserviceaccount.com",
    "client_id": process.env.CLIENT_ID,
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-bm2au%40mydoctor-6b681.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }
  

//Controllers
const { manualSignUpWithEmailPassword, signInWithGoogleOrFacebook, manualLoginWithEmailPassword , validateSession } = require('./controllers/auth_controller');
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

app.post('/api/auth/signinwithgoogleorfacebook', signInWithGoogleOrFacebook);

app.get('/api/user/userinfo', gettingLoggedUserData);

app.post('/api/session/validate', validateSession);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`Server is running on PORT ${PORT}.`);
});

