const mongoose = require('mongoose');
const Owner = require('./Owner');

const dogSchema = new mongoose.Schema({
    name: { type: String, required: true },
    age: { type: Number, required: true },
    gender: { type: String, required: true },
    color: { type: String, required: true },
    weight: { type: Number, required: true },
    distance: { type: String, required: true },
    imagePath: { type: String, required: true }, // Chemin de l'image
    description: { type: String },
    owner: { type: mongoose.Schema.Types.ObjectId, ref: 'Owner' },
});

const Dog = mongoose.model('Dog', dogSchema);

module.exports = Dog;
