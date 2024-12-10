const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const adopetRoutes = require('./routes/adopetRoutes');
const {join} = require("path");

const app = express();
const PORT = 3000;


mongoose.set('strictQuery', false);

// Connexion à MongoDB
mongoose.connect('mongodb://localhost:27017/adopetDB', { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => console.log('Connected to MongoDB'))
    .catch((err) => console.error('MongoDB connection error:', err));


app.use(cors());
app.use(bodyParser.json());

// Routes
app.use('/api', adopetRoutes);
app.use('/uploads', express.static(join(__dirname, 'uploads')));



app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
