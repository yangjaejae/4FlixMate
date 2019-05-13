const connection = require('./connection');

var testQuery = function () {
    connection.connected.query(
        "select * from user", (err, rows, fields) => {
            if (err) {
                console.log(err);
            } else {
                console.log(rows);
            }
        });
}

var loginQuery = function (pass) {
    var userEmail = "";
    connection.connected.query(
        `select email from user where pass = ${pass}`, (err, rows, fields) => {
            if (err) {
                console.log(err);
            } else {
                console.log(rows);
                userEmail = rows.email;
            }
        });
    return isValid;
}

var signinQuery = function (email, pass, name) {
    console.log("in query#######################################")
    return new Promise((resolve, reject) => {
        var isValid = false;
        var cAddress = "1234";
        console.log(email + ":" + name + ":" + pass)
        connection.connected.query(
            "insert into user(email, pass, name, cAddress) values("+email+", "+pass+", "+name+", "+cAddress+")", (err, rows, fields) => {
                if (err) {
                    console.log(err);
                } else {
                    console.log(rows);
                    isValid = true;
                }
            });
        
        if(isValid){
            resolve(true);
        }else{
            reject(false);
        }
        
    })
}

module.exports = ({
    testQuery: testQuery,
    loginQuery : loginQuery,
    singinQuery: signinQuery
});
