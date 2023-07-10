-- 1. Tüm blog yazılarını başlıkları, yazarları ve kategorileriyle birlikte getirin.

SELECT p.title, u.username AS author, c.name
FROM posts p
JOIN users u ON p.user_id = u.user_id
JOIN categories c ON p.category_id = c.category_id;

--2. En son yayınlanan 5 blog yazısını başlıkları, yazarları ve yayın tarihleriyle birlikte alın.

SELECT p.title, u.sername, p.creation_date
FROM posts p
JOIN users u ON p.user_id = u.user_id
ORDER BY p.creation_date DESC
LIMIT 5;

--3. Her blog yazısı için yorum sayısını gösterin.

SELECT p.post_id, p.title, COUNT(c.post_id)
FROM posts p
JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.title;
ORDER BY p.post_id;

--4. Tüm kayıtlı kullanıcıların kullanıcı adlarını ve e-posta adreslerini gösterin.

SELECT username, email FROM users;

--5. En son 10 yorumu, ilgili gönderi başlıklarıyla birlikte alın.

SELECT p.title, c.comment
FROM comments c
JOIN posts p ON c.post_id = p.post_id
ORDER BY c.creation_date DESC
LIMIT 10;

--6. Belirli bir kullanıcı tarafından yazılan tüm blog yazılarını bulun.

SELECT u.username, p.post_id, p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.username LIKE 'c%x';

--7. Her kullanıcının yazdığı toplam gönderi sayısını alın.

SELECT u.username, COUNT(p.post_id)
FROM users u
JOIN posts p ON u.user_id = p.user_id
GROUP BY u.username;
ORDER BY u.username;

--8. Her kategoriyi, kategorideki gönderi sayısıyla birlikte gösterin.

SELECT c.name, COUNT(p.category_id)
FROM categories c
JOIN posts p ON c.category_id = p.category_id
GROUP BY c.name;
ORDER BY c.name;

--9. Gönderi sayısına göre en popüler kategoriyi bulun.

SELECT c.name, COUNT(p.category_id)
FROM categories c
JOIN posts p ON c.category_id = p.category_id
GROUP BY c.name;
ORDER BY COUNT(p.category_id) DESC
LIMIT 1;

--10. Gönderilerindeki toplam görüntülenme sayısına göre en popüler kategoriyi bulun.

SELECT c.name, SUM(p.view_count)
FROM categories c
JOIN posts p ON c.category_id = p.category_id
GROUP BY c.name;
ORDER BY SUM(p.view_count) DESC
LIMIT 1;

--11. En fazla yoruma sahip gönderiyi alın.

SELECT p.post_id, p.title, COUNT(c.post_id)
FROM posts p
JOIN comments c ON p.post_id = c.post_id
GROUP BY p.title, p.post_id;
ORDER BY COUNT(c.post_id) DESC
LIMIT 1;

--12. Belirli bir gönderinin yazarının kullanıcı adını ve e-posta adresini gösterin.

SELECT p.post_id, u.username, u.email
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE p.post_id = 104;

--13. Başlık veya içeriklerinde belirli bir anahtar kelime bulunan tüm gönderileri bulun.
SELECT *
FROM posts
WHERE title LIKE '%Lorem%' OR content LIKE '%Lorem%';

--14. Belirli bir kullanıcının en son yorumunu gösterin.

SELECT u.username, p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.user_id = 2
GROUP BY u.username, p.content, p.creation_date
ORDER BY p.creation_date DESC
LIMIT 1;

--15. Gönderi başına ortalama yorum sayısını bulun.

SELECT AVG(comment_count) FROM(
	SELECT p.post_id, p.title, COUNT(c.comment_id) AS comment_count, ROUND(AVG(c.comment_id), 2) AS avg_comment
	FROM posts p
	JOIN comments c ON p.post_id = c.post_id
	GROUP BY p.post_id, p.title
) AS Count;

--16. Son 30 günde yayınlanan gönderileri gösterin.

SELECT * FROM posts
WHERE is_published = true AND creation_date >= CURRENT_DATE - INTERVAL '30 day';

--17. Belirli bir kullanıcının yaptığı yorumları alın.

SELECT u.username, c.comment
FROM comments c
JOIN users u ON c.user_id = u.user_id
WHERE u.username = 'sghioneix';

--18. Belirli bir kategoriye ait tüm gönderileri bulun.

SELECT c.name, *
FROM categories c
LEFT JOIN posts u ON u.category_id = c.category_id
WHERE c.name = 'Electronics';

--19. 5'ten az yazıya sahip kategorileri bulun.

SELECT name, post
FROM(SELECT c.name, COUNT(p.title) AS post
	FROM categories c
	LEFT JOIN posts p ON c.category_id = p.category_id
	GROUP BY c.name) AS lowest_comments
WHERE post < 5;

--20. Hem bir yazı hem de bir yoruma sahip olan kullanıcıları gösterin.

SELECT DISTINCT u.username
FROM users u
JOIN posts p ON u.user_id = p.user_id
JOIN comments c ON u.user_id = c.user_id;
ORDER BY u.username ASC;

--21. En az 2 farklı yazıya yorum yapmış kullanıcıları alın.
SELECT username, yorum FROM (SELECT u.username, COUNT(c.comment_id) AS yorum
FROM users u
JOIN posts p ON u.user_id = p.user_id
JOIN comments c ON u.user_id = c.user_id
GROUP BY u.username) AS yorumcu
WHERE yorum > 2;

--22. En az 3 yazıya sahip kategorileri görüntüleyin.

SELECT name, yorum
FROM (SELECT c.name, COUNT(p.title) AS yorum
FROM categories c
JOIN posts p ON c.category_id = p.category_id
GROUP BY c.name) AS category_post
WHERE yorum > 3;

--23. 5'ten fazla blog yazısı yazan yazarları bulun.

SELECT username, post
FROM (SELECT u.username, COUNT(p.title) AS post
FROM users u
JOIN posts p ON u.user_id = p.user_id
GROUP BY u.username) AS user_post
WHERE post >= 5;

--24. Bir blog yazısı yazmış veya bir yorum yapmış kullanıcıların e-posta adreslerini görüntüleyin. (UNION kullanarak)

(SELECT u.username, u.email, COUNT(p.title) AS posts
FROM users u
JOIN posts p ON u.user_id = p.user_id
GROUP BY u.username, u.email)

UNION

(SELECT u.username, u.email, COUNT(c.comment_id) AS comment
FROM users u
JOIN comments c ON u.user_id = c.user_id
GROUP BY u.username, u.email);

--25. Bir blog yazısı yazmış ancak hiç yorum yapmamış yazarları bulun.

SELECT username FROM users
WHERE (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.user_id) > 0
	AND (SELECT COUNT(*) FROM comments WHERE comments.user_id = users.user_id) = 0;
ORDER BY username;
