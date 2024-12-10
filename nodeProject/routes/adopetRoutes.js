const express = require('express');
const multer = require('multer');
const path = require('path');
const Dog = require('../models/Dog');
const Owner = require('../models/Owner');

const router = express.Router();

// Créer un nouveau propriétaire
router.post('/owner', async (req, res) => {
    try {
        const newOwner = new Owner(req.body);
        const savedOwner = await newOwner.save();
        res.status(201).json(savedOwner);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Configuration de Multer pour accepter les images
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/'); // Dossier où l'image sera stockée
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname)); // Nom unique pour chaque fichier
    }
});

const upload = multer({
    storage: storage,
    limits: { fileSize: 5 * 1024 * 1024 }, // Taille max : 5MB
    fileFilter: (req, file, cb) => {
        const filetypes = /jpeg|jpg|png|gif/;
        const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
        const mimetype = filetypes.test(file.mimetype);

        if (extname && mimetype) {
            return cb(null, true);
        } else {
            cb(new Error('Only images are allowed'));
        }
    }
});
// Route pour ajouter un chien
router.post('/add', upload.single('image'), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ message: 'No image uploaded' });
        }

        const { name, age, gender, color, weight, distance, description } = req.body;
        const imagePath = req.file.path; // Chemin de l'image sauvegardée

        // Créer un nouveau chien sans propriétaire
        const newDog = new Dog({
            name,
            age,
            gender,
            color,
            weight,
            distance,
            description,
            imagePath, // Chemin de l'image
        });

        // Sauvegarder le chien
        await newDog.save();

        res.status(201).json({ message: 'Dog added successfully', dog: newDog });
    } catch (error) {
        console.error('Error adding dog:', error);
        res.status(500).json({ message: 'Error adding dog', error: error.message });
    }
});


// Obtenir tous les chiens avec les informations du propriétaire
router.get('/dogs', async (req, res) => {
    try {
        // Récupérer les chiens sans inclure les données du propriétaire
        const dogs = await Dog.find();

        if (!dogs || dogs.length === 0) {
            // Retourner une réponse vide avec un message explicatif
            return res.status(200).json({ message: 'Aucun chien trouvé.', data: [] });
        }

        res.status(200).json(dogs); // Retourner les chiens si présents
    } catch (err) {
        // Gestion d'erreur avec un message structuré
        console.error('Erreur lors de la récupération des chiens :', err);
        res.status(500).json({ error: 'Erreur interne du serveur', details: err.message });
    }
});

// Obtenir un chien spécifique avec ses informations sans inclure owner
router.get('/dog/:id', async (req, res) => {
    try {
        const dog = await Dog.findById(req.params.id); // Pas de populate ici
        if (!dog) return res.status(404).json({ error: 'Dog not found' });
        res.status(200).json(dog); // Retourner les informations du chien sans owner
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


// Mise à jour d'un chien
router.put('/update/:id', upload.single('image'), async (req, res) => {
    try {
        const dogId = req.params.id;
        const { name, age, gender, color, weight, distance, description } = req.body;

        // Construire un objet avec uniquement les champs modifiés
        let updateData = {};

        if (name) updateData.name = name;
        if (age) updateData.age = age;
        if (gender) updateData.gender = gender;
        if (color) updateData.color = color;
        if (weight) updateData.weight = weight;
        if (distance) updateData.distance = distance;
        if (description) updateData.description = description;

        // Vérifier si une nouvelle image a été téléchargée
        if (req.file) {
            updateData.imagePath = req.file.path;  // Ajouter le chemin de l'image si elle est téléchargée
        }

        // Mettre à jour le chien avec les données modifiées
        const updatedDog = await Dog.findByIdAndUpdate(
            dogId,
            updateData,
            { new: true } // Retourner le chien mis à jour
        );

        // Vérifier si le chien a bien été trouvé et mis à jour
        if (!updatedDog) {
            return res.status(404).json({ message: 'Dog not found' });
        }

        // Répondre avec le chien mis à jour
        res.status(200).json({ message: 'Dog updated successfully', dog: updatedDog });
    } catch (error) {
        console.error('Error updating dog:', error);
        res.status(500).json({ message: 'Error updating dog', error: error.message });
    }
});


// Supprimer un chien
router.delete('/delete/:id', async (req, res) => {
    try {
        const deletedDog = await Dog.findByIdAndDelete(req.params.id);
        if (!deletedDog) return res.status(404).json({ error: 'Dog not found' });
        res.status(200).json({ message: 'Dog deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
