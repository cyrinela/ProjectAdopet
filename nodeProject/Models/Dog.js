const mongoose = require('mongoose');

const dogSchema = new mongoose.Schema({
    name: { type: String, required: true },
    age: { type: Number, required: true },
    gender: { type: String, required: true },
    color: { type: String, required: true },
    weight: { type: Number, required: true },
    distance: { type: String, required: true },
    imagePath: { type: String, required: true },
    description: { type: String }
});

const Dog = mongoose.model('Dog', dogSchema);

module.exports = Dog;
