const flixQuery = require('../../db/query');

module.exports.signin = (userInfo) => {
    
    var isValid = false;
    var email = userInfo.email;
    var pass = userInfo.pass;
    var name = userInfo.name;

    console.log(email + ":" + pass + ":" + name)

    flixQuery.singinQuery(email, pass, name)
    .then((result) => {
        isValid = result;
        console.log(result)
    })
    .catch((err) => {
        console.log(err);
    });

    return isValid;
};
