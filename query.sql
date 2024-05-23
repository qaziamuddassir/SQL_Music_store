/* Q1: Who is the senior most employee based on job title? */

Select * From employee Order by levels desc limit 1



/* Q2: Which countries have the most Invoices? */

Select billing_country
from invoice
group by billing_country
Order by billing_country DESC 
Limit 1



/* Q3: What are top 3 values of total invoice? */

Select * from invoice 
order by total Desc
Limit 3



/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT billing_city, sum(total) as total
from invoice
Group by billing_city
Order by total desc
Limit 1



/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

Select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) 
from invoice 
join customer 
on invoice.customer_id = customer.customer_id
group by customer.customer_id
order by sum(invoice.total) DESC
Limit 1



/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

Select Distinct email, first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
Where track_id IN ( 
	Select track_id from tracK
	join genre on track.genre_id = genre.genre_id
	where genre.name Like 'Rock'
	)
order by email asc



/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

Select artist.name , count(genre.name) from track
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
join genre on track.genre_id = genre.genre_id
where genre.name Like 'Rock'
group by artist.name
order by count(genre.name) DESC
limit 10



/* Q8: Return all the track names that have a song length longer than theaverage song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */ 

Select name, milliseconds from Track 
Where Milliseconds > (Select avg(Milliseconds) from track)
Order by milliseconds DESC



/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

With best_artist as(
	SELECT art.artist_id as artist_id, art.name as artist_name, sum(inl.unit_price * inl.quantity) as total_sales 
	from invoice_line as inl
	join track as tk on inl.track_id = tk.track_id
	join album as al on tk.album_id = al.album_id
	join artist AS art on al.artist_id = art.artist_id
	Group by 1
	order by total_sales Desc
	Limit 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

