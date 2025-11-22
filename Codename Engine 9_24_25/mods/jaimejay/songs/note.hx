

function onNoteCreation(event)
    if ((PlayState.SONG.meta.name == 'execretion')){
        event.noteSprite = 'game/notes/irida';
    }
    if ((PlayState.SONG.meta.name == 'execretion')){
        switch (event.player) {
        case 0:
            event.noteSprite = 'game/notes/irida';
        case 1:
            event.noteSprite = 'game/notes/irida';
        }
}



function onStrumCreation(event)
    if ((PlayState.SONG.meta.name == 'execretion')){
        event.sprite = 'game/notes/irida';
    }
    if ((PlayState.SONG.meta.name == 'execretion')){
        switch (event.player) {
        case 0:
             event.sprite = 'game/notes/irida';
        case 1:
             event.sprite = 'game/notes/irida';
            }
}