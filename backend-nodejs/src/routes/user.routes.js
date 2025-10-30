// routes/user.routes.js
const express = require('express');
const router = express.Router();
const {
  registerUser,
  getAllUsers,
  getUserById,
  updateUser,
  deleteUser
} = require('../controllers/user.controller');
const { protect, authorize } = require('../middleware/auth');

// Todas las rutas requieren autenticación y rol de admin
router.use(protect);
router.use(authorize('admin'));

router.post('/register', registerUser);
router.get('/', getAllUsers);
router.get('/:id', getUserById);
router.put('/:id', updateUser);
router.delete('/:id', deleteUser);

module.exports = router;