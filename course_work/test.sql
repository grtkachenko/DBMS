\echo 'Список всех недавно добавленных треков с количеством их вхождений в плейлисты';
select * from RecentFavouriteTrackNames;

\echo 'Список самых популярных свежих треков';
select * from MostPopularTracks;

\echo 'Получение треков первого альбома';
select GetAblumTracks(1);

\echo 'Получение списка людей, создавших второй альбом'
select GetRealPeopleNameByAlbum(1);

\echo ' Получение списка артистов, создавших тринадцатый трек'
select GetTrackArtists(13);

\echo 'Все треки 4 плейлиста'
select GetPlaylistTrackIds(4);

\echo 'Слить 3 и 4 плейлист'
select * from TrackInPlaylist where PlaylistId = 3 or PlaylistId = 4;
select MergePlaylists(3, 4);
select * from TrackInPlaylist where PlaylistId = 3 or PlaylistId = 4;
