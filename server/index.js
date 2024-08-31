const express = require('express');
const mongoose = require('mongoose');
const { createServer } = require('http');
const { Server } = require('socket.io');
var Room = require('./models/room')
const cors = require('cors');
const { triggerAsyncId } = require('async_hooks');
const { log } = require('console');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({
    origin: "*",
    methods: ["GET", "POST"]
}))


app.get('/.well-known/assetlinks.json',(req,res)=>{
    res.sendFile(__dirname + '/.well-known/assetlinks.json');
});

app.get
const server = createServer(app);
const io = new Server(server, {
    cors: {
        origin: "*", // Allow all origins for testing purposes
        methods: ["GET", "POST"]
    }
});


app.use(express.json());

const uri = "mongodb+srv://PJ:smgmYzEFd86QyupS@cluster0.zo5xg4u.mongodb.net/?retryWrites=true&w=majority";
const DB = process.env.MONGODB_URI || uri;

mongoose.connect(DB).then(() => {
    console.log('DB Connection Successful !!!!!');
}).catch((e) => {
    console.error('DB Connection Error:', e);
});

io.on("connection", (socket) => {
    console.log("A stranger connected : ID " + socket.id);




    socket.on("createRoom", async ({ nickname }) => {
        console.log("A stranger created room : nickname " + nickname);
        try {
            let room = new Room()
            let player = {
                socketId: socket.id,
                nickname: nickname,
                playerType: 'X'
            }
            room.player.push(player);
            room.turn = player;
            room = await room.save();

            const roomID = room._id.toString()
            socket.join(roomID);
            io.to(roomID).emit('roomCreated', room)
        } catch (error) {
            console.log(error);
        }
    });

    socket.on("joinRoom", async ({ nickname, roomId }) => {
        try {
            let room = await Room.findById(roomId)
            if (!roomId.match(/^[0-9a-fA-F]{24}$/) || room == null) {
                console.log("error : invalid roomId");
                socket.emit("errorOccured", "Please Enter a vaild RoomId");
                return
            }

            if (room.isJoin) {
                let player = {
                    nickname: nickname,
                    socketId: socket.id,
                    playerType: "O"
                }
                socket.join(roomId)
                room.player.push(player)
                room.isJoin = false;
                room = await room.save()
                io.to(roomId).emit('roomJoined', room)
                io.to(roomId).emit('updatePlayers', room.player)
                io.to(roomId).emit('roomUpdated', room)
            }
            else {
                socket.emit("errorOccured", "Please wait a game is in progress")
            }
        } catch (error) {
            console.log(error)
        }

    });

    socket.on('gridTap', async ({ index, roomId }) => {
        try {
            let room = await Room.findById(roomId);
            let choice = room.turn.playerType;

            room.displayElements[index] = choice;
            room.filledBoxes++;
            console.log("display Element Updated : " + room.displayElements);

            if (room.filledBoxes > 2) {
                if (room.displayElements[0] == room.displayElements[1] && room.displayElements[0] == room.displayElements[2] && room.displayElements[0] != "") {
                    console.log("1");
                    room.turn.points++;
                    await room.save();
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": true,
                        "winner": room.turn,
                    })
                }
                else if (room.displayElements[3] == room.displayElements[4] && room.displayElements[3] == room.displayElements[5] && room.displayElements[3] != "") {
                    console.log("2");
                    room.turn.points++;
                    await room.save();
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": true,
                        "winner": room.turn,
                    })
                }
                else if (room.displayElements[6] == room.displayElements[7] && room.displayElements[6] == room.displayElements[8] && room.displayElements[6] != "") {
                    console.log("3");
                    room.turn.points++;
                    await room.save();
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": true,
                        "winner": room.turn,
                    })
                }
                else if (room.displayElements[0] == room.displayElements[4] && room.displayElements[0] == room.displayElements[8] && room.displayElements[0] != "") {
                    console.log("4");
                    room.turn.points++;
                    await room.save();
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": true,
                        "winner": room.turn,
                    })
                }
                else if (room.displayElements[2] == room.displayElements[4] && room.displayElements[2] == room.displayElements[6] && room.displayElements[2] != "") {
                    console.log("5");
                    room.turn.points++;
                    await room.save();
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": true,
                        "winner": room.turn,
                    })
                }
                else if (room.displayElements[0] == room.displayElements[3] && room.displayElements[0] == room.displayElements[6] && room.displayElements[0] != "") {
                    console.log("6");
                    room.turn.points++;
                    await room.save();
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": true,
                        "winner": room.turn,
                    })
                }
                else if (room.displayElements[1] == room.displayElements[4] && room.displayElements[1] == room.displayElements[7] && room.displayElements[1] != "") {
                    console.log("7");
                    room.turn.points++;
                    await room.save();
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": true,
                        "winner": room.turn,
                    })
                }
                else if (room.displayElements[2] == room.displayElements[5] && room.displayElements[2] == room.displayElements[8] && room.displayElements[8] != "") {
                    console.log("8");
                    room.turn.points++;
                    await room.save();
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": true,
                        "winner": room.turn,
                    })
                }
                else if (room.filledBoxes >= 9) {
                    console.log("9");
                    io.to(roomId).emit("matchConluded", {
                        "winnerDeclared": false,
                    })
                }

            }

            if (room.turnIndex == 0) {
                room.turn = room.player[1];//It switches turn to other player
                room.turnIndex = 1;//
            } else {
                room.turn = room.player[0];
                room.turnIndex = 0;
            }

            console.log("Filled Boxes : " + room.filledBoxes);
            await room.save();
            io.to(roomId).emit("tapAck", {
                index,
                choice,
                room,
            })
        } catch (error) {
            console.log(error);
        }
    })
    socket.on('requestReplay', async({ roomId }) => {
        console.log("Replay Requested");
        try {
            let room = await Room.findById(roomId);
            console.log(room.player);
            let arr = [{ f: 4, a: 8 }, { f: 3, a: 6 }]
            let nickname

            if (room.player[0].socketId == socket.id) {
                nickname = room.player[0].nickname;
                room.player[0].wantsReplay = true;
                
            } else {
                room.player[1].wantsReplay = true;
                nickname = room.player[1].nickname;

            }
            console.log(room.player[0].wantsReplay+" && "+room.player[1].wantsReplay);

            if (room.player[0].wantsReplay && room.player[1].wantsReplay) {
                room.filledBoxes=0;
                room.displayElements=['','', '','','','','','',''];
                await room.save();
                io.to(roomId).emit('gameRestart',room);
            } else {
                await room.save();
                socket.to(roomId).emit('replayRequested',{nickname});
            }

        } catch (e) {
            console.log(e);
        }

    });

    socket.on("pinggg", ({ startTime }) => {
        socket.emit("pong", startTime);
    });

});

server.listen(PORT, "0.0.0.0", () => {
    console.log('Server Started and Running on PORT : ' + PORT);
});


