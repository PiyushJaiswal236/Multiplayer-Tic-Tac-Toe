const mongoose = require('mongoose')
const playerSchema = require('./player')

const roomSchema = mongoose.Schema({
    occupancy: {
        type: Number,
        default: 2,
    },
    maxRound: {
        type: Number,
        default: 2
    },
    currentRound: {
        required: true,
        type: Number,
        default: 1,
    },
    player: [playerSchema],
    isJoin: {
        type: Boolean,
        default: true
    },
    turn: playerSchema,
    turnIndex: {
        type: Number,
        default: 0
    },
    filledBoxes: {
        type: Number,
        default: 0
    },
    displayElements: {
        type: [String],
        default: ['', '', '', '', '', '', '', '', ''],
        validate: {
            validator: function(v) {
                return v.length <= 9;
            },
            message: props => `displayElements array exceeds the maximum size of 9!`
        }
    }
    
})

const roomModel = mongoose.model("Room", roomSchema);
module.exports = roomModel