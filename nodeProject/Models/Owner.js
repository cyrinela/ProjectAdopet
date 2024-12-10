const mongoose = require('mongoose');

const ownerSchema = new mongoose.Schema({
    name: { type: String, required: true },
    bio: { type: String },
    email: { type: String },
});

const Owner = mongoose.model('Owner', ownerSchema);

module.exports = Owner;
