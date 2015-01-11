drop table if exists TrackInPlaylist, TrackInAlbum, ArtistTrack, Albums, Tracks, PersonRoleInGroup, People, Roles, Artists, Playlists, Genres;

create table Genres(
    GenreId int PRIMARY KEY, 
    GenreName char(20) NOT NULL,
    UNIQUE (GenreName)
);

create table Playlists(
    PlaylistId int PRIMARY KEY, 
    PlaylistName varchar(20) NOT NULL,
    UNIQUE (PlaylistName)
);

create table Artists(
    ArtistId int PRIMARY KEY, 
    ArtistName varchar(20) NOT NULL,
    ArtistYear date NOT NULL
);

create table Roles(
    RoleId int PRIMARY KEY, 
    RoleName char(15) NOT NULL,
    UNIQUE (RoleName)
);

create table People(
    PersonId int PRIMARY KEY, 
    PersonName varchar(20) NOT NULL,
    Birthday date NOT NULL,
    Phone varchar(12)
);

create table PersonRoleInGroup(
    PersonId int, 
    ArtistId int, 
    RoleId int NOT NULL, 
    PRIMARY KEY (PersonId, ArtistId, RoleId),
    FOREIGN KEY (PersonId) REFERENCES People(PersonId) on DELETE CASCADE, 
    FOREIGN KEY (ArtistId) REFERENCES Artists(ArtistId) on DELETE CASCADE, 
    FOREIGN KEY (RoleId) REFERENCES Roles(RoleId) on DELETE CASCADE   
);

create table Tracks(
    TrackId int PRIMARY KEY, 
    TrackName varchar(20) NOT NULL,
    GenreId int NOT NULL, 
    ArtistId int NOT NULL, 
    Duration interval NOT NULL,
    BitRate int NOT NULL,
    TrackYear date NOT NULL,
    CHECK (BitRate between 0 and 320),
    FOREIGN KEY (GenreId) REFERENCES Genres(GenreId) on DELETE CASCADE,
    FOREIGN KEY (ArtistId) REFERENCES Artists(ArtistId) on DELETE CASCADE
);

create table Albums(
    AlbumId int PRIMARY KEY, 
    AlbumName varchar(20) NOT NULL,
    GenreId int NOT NULL, 
    ArtistId int NOT NULL, 
    TrackId int NOT NULL, 
    CoverUrl varchar(40),
    AlbumYear date NOT NULL, 
    FOREIGN KEY (GenreId) REFERENCES Genres(GenreId) on DELETE CASCADE,
    FOREIGN KEY (ArtistId) REFERENCES Artists(ArtistId) on DELETE CASCADE
);

create table ArtistTrack(
    ArtistId int, 
    TrackId int, 
    PRIMARY KEY (ArtistId, TrackId),
    FOREIGN KEY (ArtistId) REFERENCES Artists(ArtistId) on DELETE CASCADE DEFERRABLE INITIALLY DEFERRED, 
    FOREIGN KEY (TrackId) REFERENCES Tracks(TrackId) on DELETE CASCADE DEFERRABLE INITIALLY DEFERRED   
);

create table TrackInAlbum(
    AlbumId int, 
    TrackId int,
    PRIMARY KEY (AlbumId, TrackId),
    FOREIGN KEY (AlbumId) REFERENCES Albums(AlbumId) on DELETE CASCADE DEFERRABLE INITIALLY DEFERRED, 
    FOREIGN KEY (TrackId) REFERENCES Tracks(TrackId) on DELETE CASCADE DEFERRABLE INITIALLY DEFERRED  
);

create table TrackInPlaylist(
    PlaylistId int, 
    TrackId int, 
    PRIMARY KEY (PlaylistId, TrackId),
    FOREIGN KEY (PlaylistId) REFERENCES Playlists(PlaylistId) on DELETE CASCADE, 
    FOREIGN KEY (TrackId) REFERENCES Tracks(TrackId) on DELETE CASCADE   
);
alter table Tracks add CONSTRAINT arttr FOREIGN KEY (ArtistId, TrackId) REFERENCES ArtistTrack(ArtistId, TrackId) on DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;
alter table Albums add CONSTRAINT albtr FOREIGN KEY (AlbumId, TrackId) REFERENCES TrackInAlbum(AlbumId, TrackId) on DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;



