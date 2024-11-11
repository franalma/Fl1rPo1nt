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

const PUT_QR_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id cant be empty"),
    body('input.qr_content').notEmpty().isString().withMessage("QR content cant be empty"),
]

const REMOVE_QR_BY_USER_ID_QR_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id cant be empty"),
    body('input.qr_id').notEmpty().isString().withMessage("QR id cant be empty"),
]

const GET_QR_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id cant be empty")
]
const PUT_ALL_SOCIAL_NETWORKS_RULES = [
    body('input.networks').notEmpty().isArray().withMessage("Social networks cant be empty")
]

const PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_RULES = [
    body('input.networks').notEmpty().isArray().withMessage("Social networks cant be empty"),
    body('input.user_id').notEmpty().isString().withMessage("User id cant be empty"),
    body('input.contact_id').notEmpty().isString().withMessage("User id cant be empty")
]

const REMOVE_USER_CONTACT_BY_USER_ID_CONTACT_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id cant be empty"),
    body('input.contact_id').notEmpty().isString().withMessage("User id cant be empty")
]

const GET_USER_CONTACTS_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id cant be empty"),

];

const GET_USER_BY_DISTANCE_FROM_POINT_RULES = [
    body('input.longitude').notEmpty().isNumeric().withMessage("Longitude is required"),
    body('input.latitude').notEmpty().isNumeric().withMessage("Latitude is required"),
    body('input.radio').notEmpty().isNumeric().withMessage("Radio is required"),

];







module.exports = {
    NEW_USER_VALIDATION_RULES,
    DO_LOGIN_RULES,
    PUT_QR_BY_USER_ID_RULES,
    REMOVE_QR_BY_USER_ID_QR_ID_RULES,
    GET_QR_BY_USER_ID_RULES,
    PUT_ALL_SOCIAL_NETWORKS_RULES,
    PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_RULES,
    REMOVE_USER_CONTACT_BY_USER_ID_CONTACT_ID_RULES,
    GET_USER_CONTACTS_BY_USER_ID_RULES,
    GET_USER_BY_DISTANCE_FROM_POINT_RULES

}