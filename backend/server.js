const express = require('express')
const app = express()
const bodyParser = require('body-parser');

const admin = require("firebase-admin");
const credentials = require("./serviceAccountKey.json");

//Controllers
const { manualSignUpWithEmailPassword } = require('./controllers/auth_controller');

admin.initializeApp({
    credential: admin.credential.cert(credentials)
});

app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

//Routes
app.post('/api/auth/manualsignup', manualSignUpWithEmailPassword);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`Server is running on PORT ${PORT}.`);
});

