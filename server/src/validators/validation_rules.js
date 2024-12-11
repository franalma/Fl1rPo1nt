const { body } = require('express-validator');



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

const PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID_RULES = [    
    body('input.user_id').notEmpty().isString().withMessage("User id cant be empty"),
    body('input.user_qr_id').notEmpty().isString().withMessage("User QR id cant be empty"),
    body('input.contact_id').notEmpty().isString().withMessage("Contact id cant be empty"),
    body('input.contact_qr_id').notEmpty().isString().withMessage("Qr id  cant be empty"),
    body('input.flirt_id').notEmpty().isString().withMessage("Flirt id  cant be empty"),
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


const UPDATE_USER_NETWORK_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),
    body('input.values.networks').notEmpty().isArray().withMessage("Networks are required"),

];


const UPDATE_USER_SEARCHING_RANGE_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),
    body('input.distance').notEmpty().isNumeric().withMessage("Distance is required"),

];

const UPDATE_USER_INTERESTS_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),
    body('input.values.user_interests').notEmpty().isObject().withMessage("User interestes are required"),

];

const UPDATE_USER_QRS_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),
    body('input.qr_values').notEmpty().isArray().withMessage("QR values are required"),

];


const PUT_USER_FLIRT_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),
    body('input.user_interests').notEmpty().isObject().withMessage("Relation id required"),
    body('input.gender').notEmpty().isObject().withMessage("Gender id required"),
    body('input.location').notEmpty().isObject().withMessage("Location is required"),

];

const UPDATE_USER_FLIRT_BY_USER_ID_FLIRT_ID_RULES = [
    body('input.user_id').optional().isString().withMessage("User id is required"),
    body('input.flirt_id').notEmpty().isString().withMessage("Flirt id required"),
    body('input.values').notEmpty().isObject().withMessage("Values are required")

];

const GET_USER_FLIRTS_RULES = [
    body('input.filters.user_id').notEmpty().isString().withMessage("User id is required"),
    body('input.filters').notEmpty().isObject().withMessage("Flirt id required")
];

const GET_USER_IMAGES_BY_USER_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
];


const REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.file_id').notEmpty().isString().withMessage("File id is required"),    
];

const UPDATE_USER_BIOGRAPHY_BY_USER_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.biography').notEmpty().isString().withMessage("Biography  is required"),    
];

const UPDATE_USER_HOBBIES_BY_USER_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.hobbies').notEmpty().isArray().withMessage("Hobbies are required"),    
];


const UPDATE_USER_NAME_BY_USER_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.user_name').notEmpty().isString().withMessage("Name is required"),    
];

const UPDATE_USER_IMAGE_PROFILE_BY_USER_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.image_id').notEmpty().isString().withMessage("Image id is required"),    
];

const UPDATE_USER_DEFAULT_QR_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.qr_id').notEmpty().isString().withMessage("QR id is required"),    
];

const GET_ACTIVE_FLIRTS_FROM_POINT_AND_TENDENCY_RULES = [
    body('input.flirt_id').notEmpty().isString().withMessage("Flirt id is required"),    
    body('input.sex_alternative').notEmpty().isObject().withMessage("Sex alternative id is required"),  
    body('input.relationship').notEmpty().isObject().withMessage("Relationship  is required"),  
    body('input.gender_interest').notEmpty().isObject().withMessage("Gender interest  is required"),  
    body('input.longitude').notEmpty().isNumeric().withMessage("Longitude is required"),  
    body('input.latitude').notEmpty().isNumeric().withMessage("Latitude is required"),  
    body('input.radio').notEmpty().isNumeric().withMessage("Radio is required"),  
    body('input.filters_enabled').notEmpty().isBoolean().withMessage("Filters flag is required"),  

];

const UPDATE_USER_RADIO_VISIBILITY_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.radio_visibility').notEmpty().isNumeric().withMessage("Radio is required"),  

];

const UPDATE_USER_GENDER_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.gender').notEmpty().isObject().withMessage("Gender is required"),  

];




const DISABLE_MATCH_BY_MATCH_ID_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.match_id').notEmpty().isString().withMessage("match_id is required"),  

];
const GET_USER_PUBLIC_PROFILE_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
   

];

const GET_PROTECTED_IMAGES_URLS_BY_USER_ID_RULES = [
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    

];

const GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID_RULES = [    
    body('input.values').notEmpty().isArray().withMessage("values are required"),    

];

const PUT_SMART_POINT_BY_USER_ID_RULES = [    
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.name').optional().isString().withMessage("No valid value for name"),    
    body('input.phone').optional().isString().withMessage("No valid value for phone"),    
    body('input.networks').optional().isArray().withMessage("No valid value for social networks"),    
];

const UPDATE_SMART_POINT_STATUS_BY_POINT_ID_RULES = [    
    body('input.point_id').notEmpty().isString().withMessage("Point id is required"),    
    body('input.status').notEmpty().isNumeric().withMessage("Status value is required"),    
];


const UPDATE_SMART_POINTS_STATUS_BY_USER_ID_RULES = [    
    body('input.values.user_id').notEmpty().isString().withMessage("User id is required"),    
    body('input.values.status').notEmpty().isNumeric().withMessage("Status value is required"),    
];

const GET_ALL_SMART_POINTS_BY_USER_ID_RULES = [    
    body('input.user_id').notEmpty().isString().withMessage("User id is required"),        
];

module.exports = {
    // NEW_USER_VALIDATION_RULES,
    DO_LOGIN_RULES,
    PUT_QR_BY_USER_ID_RULES,
    REMOVE_QR_BY_USER_ID_QR_ID_RULES,
    GET_QR_BY_USER_ID_RULES,
    PUT_ALL_SOCIAL_NETWORKS_RULES,
    PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID_RULES,
    REMOVE_USER_CONTACT_BY_USER_ID_CONTACT_ID_RULES,
    GET_USER_CONTACTS_BY_USER_ID_RULES,
    GET_USER_BY_DISTANCE_FROM_POINT_RULES,
    UPDATE_USER_NETWORK_BY_USER_ID_RULES,
    UPDATE_USER_SEARCHING_RANGE_BY_USER_ID_RULES,
    UPDATE_USER_INTERESTS_BY_USER_ID_RULES,
    UPDATE_USER_QRS_BY_USER_ID_RULES,
    PUT_USER_FLIRT_BY_USER_ID_RULES,
    UPDATE_USER_FLIRT_BY_USER_ID_FLIRT_ID_RULES,
    GET_USER_FLIRTS_RULES,
    GET_USER_IMAGES_BY_USER_RULES,
    REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_RULES,
    UPDATE_USER_BIOGRAPHY_BY_USER_RULES,
    UPDATE_USER_HOBBIES_BY_USER_RULES,
    UPDATE_USER_NAME_BY_USER_RULES,
    UPDATE_USER_IMAGE_PROFILE_BY_USER_RULES,
    UPDATE_USER_DEFAULT_QR_BY_USER_ID_RULES,
    GET_ACTIVE_FLIRTS_FROM_POINT_AND_TENDENCY_RULES,
    UPDATE_USER_RADIO_VISIBILITY_BY_USER_ID_RULES,
    UPDATE_USER_GENDER_BY_USER_ID_RULES,
    DISABLE_MATCH_BY_MATCH_ID_USER_ID_RULES,
    GET_USER_PUBLIC_PROFILE_BY_USER_ID_RULES,
    GET_PROTECTED_IMAGES_URLS_BY_USER_ID_RULES,
    GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID_RULES,
    PUT_SMART_POINT_BY_USER_ID_RULES,
    UPDATE_SMART_POINT_STATUS_BY_POINT_ID_RULES,
    UPDATE_SMART_POINTS_STATUS_BY_USER_ID_RULES,
    GET_ALL_SMART_POINTS_BY_USER_ID_RULES
}