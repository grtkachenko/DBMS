
insert into Genres
    (GenreId, GenreName) values
    (1, 'Blues'),
    (2, 'Country'),
    (3, 'Pop'),
    (4, 'Folk'),
    (5, 'Rock');

insert into Playlists
    (PlaylistId, PlaylistName) values
    (1, 'Juggling'),
    (2, 'Latest');

insert into Artists
    (ArtistId, ArtistName, ArtistYear) values
    (1, 'Rihanna', '20/Jan/94'),
    (2, 'Maroon5', '21/Feb/98');

insert into Roles
    (RoleId, RoleName) values
    (1, 'Singer'),
    (2, 'Drums');

insert into People
    (PersonId, PersonName, Birthday, Phone) values
    (1, 'Robyn Fenty', '20/Feb/88', '+79650798805'),
    (2, 'Adam Levine',   '18/Mar/79', '+79650791234');

insert into PersonRoleInGroup
    (PersonId, ArtistId, RoleId) values
    (1, 1, 1),
    (1, 2, 1),
    (2, 2, 1),
    (2, 2, 2);

begin;
insert into Tracks
    (TrackId, TrackName, GenreId, ArtistId, Duration, BitRate, TrackYear) values
    (1, 'Misery', 3, 2, '3 minutes', 320, '20/Jan/2000'), 
    (2, 'Animals', 3, 2, '2 minutes 15 seconds', 320, '15/Jan/1994');

insert into ArtistTrack
    (ArtistId, TrackId) values
    (1, 1),
    (2, 1), 
    (2, 2);
commit;

begin;
insert into Albums
    (AlbumId, AlbumName, GenreId, ArtistId, TrackId, CoverUrl, AlbumYear) values
    (1, 'Hands All Over', 3, 2, 1, 'http://bit.ly/1BNuyYU', '20/Jan/2000');

insert into TrackInAlbum
    (AlbumId, TrackId) values
    (1, 1),
    (1, 2);
commit;

insert into TrackInPlaylist
    (PlaylistId, TrackId, TimeAdded) values
    (1, 1, '20/Jan/2000'),
    (1, 2, '20/Jan/2000');




