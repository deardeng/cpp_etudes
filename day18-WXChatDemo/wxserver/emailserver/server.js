const emailModule = require('./email');

async function main(){

    let mailOptions = {
        from: 'secondtonone1@163.com',
        to: '1017234088@qq.com',
        subject: '验证码',
        text: '您的验证码为sdfaf，请三分钟内完成注册'
    };

    let send_res = await emailModule.SendMail(mailOptions);
    console.log("send res is ", send_res)
    console.log("main exeit")
} 

main();