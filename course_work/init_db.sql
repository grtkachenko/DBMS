drop trigger if exists AlbumYearTrigger on Albums;
drop trigger if exists TimeAddedOfTrackTrigger on TrackInPlaylist;
drop trigger if exists PlaylistTrackNumberTrigger on TrackInPlaylist;
drop trigger if exists MostPopularTrackRefresher on TrackInPlaylist;
drop trigger if exists GenreOfAlbumTrigger on TrackInAlbum;
drop function if exists GetAblumTracks(int);
drop function if exists GetRealPeopleNameByAlbum(int);
drop function if exists GetTrackArtists(int);
drop function if exists GetPlaylistTrackIds(int);
drop function if exists check_album_year();
drop function if exists check_playlist_track_number();
drop function if exists update_most_popular_tracks();
drop function if exists check_album_tracks_genre();
drop function if exists update_added_time();
drop materialized view if exists MostPopularTracks;
drop view if exists RecentFavouriteTrackIds, RecentFavouriteTrackNames;

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
    RoleName varchar(15) NOT NULL,
    UNIQUE (RoleName)
);

create table People(
    PersonId int PRIMARY KEY, 
    PersonName varchar(40) NOT NULL,
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
    TrackName varchar(40) NOT NULL,
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
    TimeAdded date,
    PRIMARY KEY (PlaylistId, TrackId),
    FOREIGN KEY (PlaylistId) REFERENCES Playlists(PlaylistId) on DELETE CASCADE, 
    FOREIGN KEY (TrackId) REFERENCES Tracks(TrackId) on DELETE CASCADE   
);
alter table Tracks add CONSTRAINT arttr FOREIGN KEY (ArtistId, TrackId) REFERENCES ArtistTrack(ArtistId, TrackId) on DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;
alter table Albums add CONSTRAINT albtr FOREIGN KEY (AlbumId, TrackId) REFERENCES TrackInAlbum(AlbumId, TrackId) on DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

-- Triggers

create function check_playlist_track_number() returns trigger AS $$
    BEGIN
        if ((select count(*)
            from TrackInPlaylist
            where TrackInPlaylist.PlaylistId = NEW.PlaylistId) > 50) THEN
            RAISE EXCEPTION 'Too many tracks in <<%>>', (select Playlists.PlaylistName from Playlists where Playlists.PlaylistId = NEW.PlaylistId);
        END IF;        
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

create function check_album_year() returns trigger AS $$
    DECLARE 
        target_artist Artists%ROWTYPE;
    BEGIN
        select * into target_artist from Artists where Artists.ArtistId = NEW.ArtistId;
        IF (target_artist.ArtistYear > NEW.AlbumYear) THEN
            RAISE EXCEPTION 'Incorrect year of <<%>>', NEW.AlbumName;
        END IF;        
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

create function check_album_tracks_genre() returns trigger AS $$
    DECLARE 
        target_genre Genres%ROWTYPE;
        album_name Albums.AlbumName%TYPE;
    BEGIN
        select Genres.GenreId, Genres.GenreName into target_genre from Albums natural join Genres where Albums.AlbumId = NEW.AlbumId;

        IF EXISTS (select * from TrackInAlbum natural join Tracks where TrackInAlbum.AlbumId = NEW.AlbumId and Tracks.GenreId <> target_genre.GenreId) THEN
            select Albums.AlbumName into album_name from Albums where Albums.AlbumId = NEW.AlbumId;
            RAISE EXCEPTION 'Invalid tracks genre of album <<%>>', album_name;
        END IF;        
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

create function update_added_time() returns trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT' or (TG_OP = 'UPDATE' and NEW.TimeAdded <> OLD.TimeAdded)) THEN
            update TrackInPlaylist set TimeAdded = localtimestamp 
                where NEW.TrackId = TrackId and NEW.PlaylistId = PlaylistId;
        END IF;    
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

create function update_most_popular_tracks() returns trigger AS $$
    BEGIN
        REFRESH MATERIALIZED VIEW MostPopularTracks;   
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


create trigger PlaylistTrackNumberTrigger after update or insert on TrackInPlaylist 
    for each row execute procedure check_playlist_track_number();

create trigger AlbumYearTrigger after update or insert on Albums 
    for each row execute procedure check_album_year();

create trigger GenreOfAlbumTrigger after update or insert on TrackInAlbum 
    for each row execute procedure check_album_tracks_genre();

create trigger TimeAddedOfTrackTrigger after update or insert on TrackInPlaylist 
    for each row execute procedure update_added_time();

create trigger MostPopularTrackRefresher after update or insert or delete on TrackInPlaylist 
    for each statement execute procedure update_most_popular_tracks();

-- Functions
create function GetAblumTracks(album_id int) returns table(track_id int) as $$
    begin
        return query 
            (select Tracks.TrackId as track_id from Tracks where 
                exists (select * from TrackInAlbum where TrackInAlbum.TrackId = Tracks.TrackId and TrackInAlbum.AlbumId = album_id));
    end;
$$ language plpgsql;

create function GetRealPeopleNameByAlbum(album_id int) returns table(name varchar, role varchar) as $$
     DECLARE 
        artist_id Artists.ArtistId%TYPE;
    begin
        select Albums.ArtistId into artist_id from Albums where Albums.AlbumId = album_id;
        return query 
            (select People.PersonName as name, Roles.RoleName as role from PersonRoleInGroup natural join Roles natural join People 
                where PersonRoleInGroup.ArtistId = artist_id);
    end;
$$ language plpgsql;

create function GetTrackArtists(track_id int) returns setof varchar as $$
    begin
        return query 
            (select Artists.ArtistName from ArtistTrack natural join Artists where 
                ArtistTrack.TrackId = track_id);
    end;
$$ language plpgsql;

create function GetPlaylistTrackIds(playlist_id int) returns table(track_id varchar) as $$
    begin
        return query 
            (select TrackInPlaylist.TrackId as track_id from TrackInPlaylist
                where TrackInPlaylist.PlaylistId= playlist_id);
    end;
$$ language plpgsql;


-- Views
create view RecentFavouriteTrackIds as 
select RecentTracks.TrackId, count (*) as Cnt from 
    (select * from Tracks natural join TrackInPlaylist 
        where localtimestamp - TrackInPlaylist.TimeAdded <= interval '5 months') as RecentTracks group by RecentTracks.TrackId;

create view RecentFavouriteTrackNames as 
    select RecTracks.TrackName, RecTracks.Cnt from 
        (Tracks natural join (select * from RecentFavouriteTrackIds) as RecFavTrIds) as RecTracks;

create materialized view MostPopularTracks as 
    select RecentFavouriteTrackNames.TrackName from RecentFavouriteTrackNames where 
        RecentFavouriteTrackNames.Cnt = (select max(RecentFavouriteTrackNames.Cnt) from RecentFavouriteTrackNames);
        
-- Indexes 
create index RecentTracksInPlaylist on TrackInPlaylist(TimeAdded);




