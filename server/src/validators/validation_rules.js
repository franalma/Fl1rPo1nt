const { body } = require('express-validator');

const NEW_USER_VALIDATION_RULES = [
    body('input.name').notEmpty().withMessage("Name cant be empty"),
    body('input.surname').optional(),
    body('input.phone').isMobilePhone().withMessage("Phone number is mandatory"),
    body('input.email').notEmpty().isEmail().withMessage("eMail cant be empty"),
    body('input.password')
        .isLength({ min: 8 }).withMessage('La contraseña debe tener al menos 8 caracteres')
        .matches(/[A-Z]/).withMessage('La contraseña debe contener al menos una letra mayúscula')
        .matches(/[a-z]/).withMessage('La contraseña debe contener al menos una letra minúscula')
        .matches(/\d/).withMessage('La contraseña debe contener al menos un número')
        .matches(/[@$!%*?&]/).withMessage('La contraseña debe contener al menos un carácter especial (@, $, !, %, *, ?, &)'),
    body("input.zip_code").isNumeric().withMessage("Zip code must be a number"),
    


];

const DO_LOGIN_RULES = [
    body('input.email').notEmpty().isEmail().withMessage("eMail cant be empty"),
    body('input.password').notEmpty().withMessage("Password cant be empty")
];


module.exports = {
    NEW_USER_VALIDATION_RULES,
    DO_LOGIN_RULES
}