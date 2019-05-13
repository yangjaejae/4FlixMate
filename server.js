const express = require('express');        // call express
const app = express(); 
const expressLayouts = require('express-ejs-layouts');
const bodyParser = require('body-parser');

const usersModule = require('./service/user/users');

app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');

app.use(express.static('static'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get("/login", function(req, res){
    res.render('login', {
        title: 'fourflix',
        description: 'this is fourflix page'
    })
});
app.post("/login", function(req, res){

    console.log("login");

});
app.get("/signin", function(req, res){
    res.render('signin', {
        title: 'fourflix',
        description: 'this is fourflix page'
    })
});
app.post("/signin", function(req, res){

    console.log("post signin");
    let userInfo = {
        name: req.body.name, 
        email: req.body.email, 
        pass: req.body.password
    }
    // contract 주소 생성해서 추가 
    // userInfo.cAddress = "";

    var isValid = usersModule.signin(userInfo);

    if(isValid){
        res.redirect('/login');
    }else{
        res.redirect('/signin');
    }
});
app.get("/mate", function(req, res){
    res.render('mate', {
        title: 'fourflix',
        description: 'this is fourflix page'
    })
});
app.get("/mate_success", function(req, res){
    res.render('mate_success', {
        title: 'fourflix',
        description: 'this is fourflix page'
    })
});
app.get("/mate_progress", function(req, res){
    res.render('mate_progress', {
        title: 'fourflix',
        description: 'this is fourflix page'
    })
});
app.get("/community", function(req, res){
    res.render('community', {
        title: 'fourflix',
        description: 'this is fourflix page'
    })
});
app.get("/mypage", function(req, res){
    res.render('mypage', {
        title: 'fourflix',
        description: 'this is fourflix page'
    })
});
// Save our port
var port = process.env.PORT || 3000;

// Start the server and listen on port 
app.listen(port, function () {
    console.log("Live on port: " + port);
});