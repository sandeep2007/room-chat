
const Database = require('./Database');
const conn = new Database()

const dateFormat = require('dateformat');
const fn = require('./functions');

let obj = {};

const userTableName = process.env.USER_TABLE_NAME;
const encryptionKey = process.env.APP_SECRET_KEY;
const tokenColumn = process.env.USER_TOKEN_COLUMN;
const dbPrefix = process.env.DATABASE_PREFIX;

obj.verifyToken = async (token, socket) => {
    let date = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
    let userData = await conn.query("SELECT t1.name,t1.image,'" + date + "' as last_seen,t1." + tokenColumn + ",t1.id,t1.email from " + userTableName + " as t1 WHERE t1." + tokenColumn + "='" + token + "' LIMIT 1");

    if (!fn.isEmpty(userData)) {
        checkUserToken = await conn.query("select id from " + fn.getTableName('socket_users') + " where socket_id='" + socket.id + "' LIMIT 1");
        if (fn.isEmpty(checkUserToken)) {
            await conn.query("Insert into " + fn.getTableName('socket_users') + "(token,socket_id,date_created) values('" + token + "','" + socket.id + "','" + dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss") + "')");
        }
        else {
            await conn.query("update " + fn.getTableName('socket_users') + " set socket_id='" + socket.id + "' where token='" + token + "'");
        }
        obj.lastSeen(userData[0]['id'], 'LOGIN');
        return userData[0];
    }
    return false;
}

obj.userList = (data, callback) => {
    conn.query("select IF((select t3.id from " + fn.getTableName('socket_users') + " as t3 where t3.token=t1." + tokenColumn + " order by t3.date_created DESC LIMIT 1), 'ONLINE','OFFLINE') as is_online,(select date_created from " + fn.getTableName('last_seen') + " where user_id=t1.id order by date_created DESC LIMIT 1) as last_seen,t1.id,t1.email,t1.name,t1.image from " + userTableName + " as t1 where t1.email!='' order by FIELD(is_online,'ONLINE','OFFLINE')").then((userList) => {
        callback(userList);
    });
}

obj.userChatInput = (data, callback) => {
    let date = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");

    conn.query("insert into " + fn.getTableName('chat') + "(sender_id, channel_id, message, date_created) values(?,?,AES_ENCRYPT(?, ?),?)", [data.senderId, data.channelId, data.message, encryptionKey, date]).then((data1) => {
        // console.log(data1.insertId);
        callback(null, { id: data1.insertId, senderId: data.senderId, channelId: data.channelId, date_created: date, message: data.message });
        //callback(data);
    }).catch((err) => {
        callback(err, null);
    });
}

obj.seenMessage = (data, callback) => {
    conn.query("select t1.socket_id from " + fn.getTableName('socket_users') + " as t1 join " + userTableName + " as t2 on t2." + tokenColumn + "=t1.token where t2.id='" + data.senderId + "' LIMIT 1").then((senderData) => {
        conn.query("update " + fn.getTableName('chat') + " set is_seen='1' where sender_id='" + data.senderId + "' and channel_id = '" + data.channelId + "'").then((data1) => {
            if (!fn.isEmpty(senderData)) {
                callback({ senderId: data.senderId, channelId: data.channelId, senderSocketId: senderData[0].socket_id });
            }
            else {
                callback({ senderId: data.senderId, channelId: data.channelId, senderSocketId: null });
            }
        });
    })
}

obj.getUserSocketId = (userId, callback) => {
    conn.query("select t1.socket_id from " + fn.getTableName('socket_users') + " as t1 join " + userTableName + " as t2 on t2." + tokenColumn + " = t1.token where t2.id = '" + userId + "'").then((data) => {
        if (!fn.isEmpty(data)) {
            callback(null, data);
        }
        else {
            callback('not found', null);
        }

    }).catch((err) => {
        callback(err, null);
    });
};

obj.clearSocketUsers = () => {
    conn.query("delete from " + fn.getTableName('socket_users') + "");
}

obj.userChatList = (data, callback) => {
    conn.query("select t2.name as userName,t1.id,CAST(AES_DECRYPT(t1.message, '" + encryptionKey + "') AS CHAR) as message,t1.date_created,t1.channel_id as channelId,t1.sender_id as senderId,t1.is_seen from " + fn.getTableName('chat') + " as t1 left join " + userTableName + " as t2 on t2.id=t1.sender_id where t1.channel_id='" + data.channelId + "' order by t1.date_created desc LIMIT 10").then((data1) => {
        //console.log(data1)
        callback(data1);
        // conn.query("update " + fn.getTableName('chat') + " set is_seen='1' where channel_id='" + data.senderId + "' and sender_id='" + data.receiverId + "'").then(() => {
        //     callback(data1);
        // });
    });
}

obj.deleteUserToken = (socket, callback) => {
    obj.lastSeen(socket.userData.id, 'LOGOUT');
    conn.query("delete from " + fn.getTableName('socket_users') + " where socket_id='" + socket.id + "'").then((data) => {

        if (callback) {
            callback(data);
        }
    });
}

obj.lastSeen = (userId, userAction) => {
    let date = dateFormat(new Date(), "yyyy-mm-dd HH:MM:ss");
    conn.query(`insert into ${fn.getTableName('last_seen')}(user_id,action,date_created) values('${userId}','${userAction}','${date}')`)
}

module.exports = obj;