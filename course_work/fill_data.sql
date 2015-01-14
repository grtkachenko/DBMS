
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
    (2, 'Before sleep'),
    (3, 'For mom'),
    (4, 'Just Rasmus'),
    (5, 'For jogging'),
    (6, 'Party hard');

insert into Artists
    (ArtistId, ArtistName, ArtistYear) values
    (1, 'Rihanna', '20/Jan/94'),
    (2, 'Maroon 5', '1/Jan/1994'),
    (3, 'Christina Aguilera', '1/Jan/1991'),
    (4, 'The Rasmus', '1/Jan/1994')
    ;

insert into Roles
    (RoleId, RoleName) values
    (1, 'Vocals'),
    (2, 'Drums'),
    (3, 'Guitarist'), 
    (4, 'Piano');

insert into People
    (PersonId, PersonName, Birthday) values
    (1, 'Robyn Fenty', '20/Feb/88'),
    (2, 'Adam Levine', '18/Mar/79'),
    (3, 'Christina Maria Aguilera', '18/Dec/80'),
    (4, 'James Burgon Valentine', '5/Oct/78'),
    (5, 'Matt Flynn', '23/May/78'),
    (6, 'Pauli Rantasalmi', '13/Jan/1979'),
    (7, 'Aki Hakala', '1/Apr/1979'),
    (8, 'Lauri Ylönen', '27/Nov/1978')
    ;

insert into PersonRoleInGroup
    (PersonId, ArtistId, RoleId) values
    (1, 1, 1),
    (1, 2, 1),
    (2, 2, 1),
    (3, 3, 1),
    (4, 2, 3),
    (5, 2, 2),
    (6, 4, 3),
    (7, 4, 2),
    (8, 4, 1)
    ;

begin;
insert into Tracks
    (TrackId, TrackName, GenreId, ArtistId, Duration, BitRate, TrackYear) values
    (1, 'Misery', 3, 2, '3 minutes', 320, '22/Jun/2010'), 
    (2, 'Give a Little More', 3, 2, '2 minutes', 240, '04/Apr/2011'), 
    (3, 'Slutter', 3, 2, '3 minutes', 240, '22/Dec/2010'), 
    (4, 'Dont Know Nothing', 3, 2, '2 minutes', 320, '10/Jan/2011'), 
    (5, 'Never gonna leave', 3, 2, '2 minutes', 320, '20/Feb/2011'), 
    (6, 'I cant lie', 3, 2, '2 minutes 30 seconds', 320, '2/Jan/2011'), 
    (7, 'Hands all over', 3, 2, '3 minutes 15 seconds', 128, '25/Jan/2011'), 
    (8, 'How', 3, 2, '1 minutes 10 second', 320, '8/Jan/2011'), 
    (9, 'Get Back in My Life', 3, 2, '2 minutes', 320, '5/Jan/2011'), 
    (10, 'Just a Feeling', 3, 2, '3 minutes', 128, '11/May/2011'), 
    (11, 'Runaway', 3, 2, '3 minutes', 320, '20/May/2011'), 
    (12, 'Out of Goodbyes', 3, 2, '3 minutes 13 seconds', 128, '16/May/2011'), 
    (13, 'Move like Jagger', 3, 2, '3 minutes 21 seconds', 320, '21/Jun/2011'),
    (14, 'Birthday Cake', 3, 1, '2 minutes 40 seconds', 320, '10/Aug/2013'),
    (15, 'Cry', 3, 1, '3 minutes', 240, '1/Aug/2008'),
    (16, 'Livin in a World Without You', 5, 4, '3 minutes 50 second', 320, '1/Sep/2007'),
    (17, 'Ten Black Roses', 5, 4, '3 minutes 55 second', 320, '1/Sep/2007'),
    (18, 'Ghost of Love', 5, 4, '3 minutes 17 second', 320, '12/Oct/2007'),
    (19, 'Justify', 5, 4, '4 minutes 26 second', 320, '18/Sep/2007'),
    (20, 'Your Forgiveness', 5, 4, '3 minutes 55 second', 320, '18/Sep/2007'),
    (21, 'Run to You', 5, 4, '4 minutes 50 second', 320, '1/Sep/2007'),
    (22, 'You Got It Wrong', 5, 4, '3 minutes 15 second', 320, '12/Sep/2007'),
    (23, 'Lost and Lonely', 5, 4, '4 minutes 46 second', 320, '1/Sep/2007'),
    (24, 'The Fight', 5, 4, '3 minutes 45 second', 320, '1/Nov/2007'),
    (25, 'Dangerous Kind', 5, 4, '3 minutes 46 second', 320, '12/Sep/2007'),
    (26, 'Live Forever', 5, 4, '3 minutes 20 second', 320, '1/Sep/2007');

insert into ArtistTrack
    (ArtistId, TrackId) values
    (2, 1),
    (2, 2), 
    (2, 3),
    (2, 4), 
    (2, 5),
    (2, 6), 
    (2, 7),
    (2, 8), 
    (2, 9),
    (2, 10), 
    (2, 11), 
    (2, 12), 
    (2, 13), 
    (3, 13),
    (1, 14),
    (1, 15),
    (4, 16),
    (4, 17),
    (4, 18),
    (4, 19),
    (4, 20),
    (4, 21),
    (4, 22),
    (4, 23),
    (4, 24),
    (4, 25),
    (4, 26);
commit;

begin;
insert into Albums
    (AlbumId, AlbumName, GenreId, ArtistId, TrackId, CoverUrl, AlbumYear) values
    (1, 'Hands All Over', 3, 2, 1, 'http://bit.ly/1BNuyYU', '20/Jan/2000'),
    (2, 'Black Roses', 5, 4, 16, 'http://bit.ly/1y7DzN4', '20/Jan/2000');

insert into TrackInAlbum
    (AlbumId, TrackId) values
    (1, 1),
    (1, 2), 
    (1, 3),
    (1, 4), 
    (1, 5),
    (1, 6), 
    (1, 7),
    (1, 8), 
    (1, 9),
    (1, 10), 
    (1, 11), 
    (1, 12),    
    (2, 16),
    (2, 17),
    (2, 18),
    (2, 19),
    (2, 20),
    (2, 21),
    (2, 22),
    (2, 23),
    (2, 24),
    (2, 25),
    (2, 26);
commit;

insert into TrackInPlaylist
    (PlaylistId, TrackId) values
    (1, 1),
    (1, 13),
    (1, 15),
    (1, 16),
    (1, 21),
    (2, 1),
    (2, 2),
    (2, 7),
    (2, 9),
    (2, 10),
    (2, 11),
    (2, 13),
    (2, 20),
    (3, 13),
    (3, 18),
    (4, 16),
    (4, 17),
    (4, 18),
    (4, 19),
    (4, 20),
    (4, 21),
    (4, 22),
    (4, 23),
    (4, 24),
    (4, 25),
    (4, 26),
    (5, 1),
    (5, 2),
    (5, 3),
    (5, 4),
    (5, 5),
    (5, 6),
    (5, 7),
    (5, 8),
    (5, 9),
    (5, 10),
    (5, 11),
    (5, 12),
    (5, 16),
    (5, 17),
    (5, 18),
    (5, 19),
    (5, 20),
    (5, 21),
    (5, 22),
    (5, 23),
    (5, 24),
    (5, 25),
    (5, 26),
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4),
    (6, 6),
    (6, 7),
    (6, 8),
    (6, 10),
    (6, 11),
    (6, 12),
    (6, 13),
    (6, 14),
    (6, 16),
    (6, 17),
    (6, 19),
    (6, 20),
    (6, 22),
    (6, 23),
    (6, 24),
    (6, 25),
    (6, 26);