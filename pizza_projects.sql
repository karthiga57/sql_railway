create database pizza;
use pizza;
select * from pizzas;
select * from pizza_types;
create table orders (order_id int not null,
order_date date not  null,
order_time  time not null,
primary key(order_id));
select * from orders;
create table order_details(order_detials_id int not null,
order_id int not null,
pizza_id text not null,
quantity int  not null, 
primary key(order_detials_id));
---  retrieve the total numbers of orders 

select count(order_id) as total_orders from  orders;

 --- calculate the total revenue generated from pizza sales
select round(sum(order_detials.quantity* pizzas.price),2) as total_sales from order_detials join pizzas
on pizzas.pizza_id=order_detials.pizza_id;

--- identify the highest -price pizza
select  pizza_types.name , pizzas.price from  pizza_types join
 pizzas on  pizza_types.pizza_type_id=pizzas.pizza_type_id
 order by pizzas.price desc limit 10 ;
 
 --- identify the most common pizza size ordered
 
 select quantity, count(order_detials_id) from order_detials group by quantity;
 
 select pizzas.size ,count(order_detials.order_detials_id) as order_count
from pizzas join order_detials on pizzas.pizza_id=order_detials.pizza_id
group by pizzas.size order by order_count desc;


--- identify thetop 5  most pizza types along with their quantites 


select pizza_types.name, sum(order_detials.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id join order_detials
on order_detials.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by quantity  limit 12;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,sum(order_detials.quantity) as quantity 
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_detials on order_detials.pizza_id=pizzas.pizza_id
group by pizza_types.category order  by quantity  desc;

--- Determine the distribution of orders by hour of the day.

select hour(order_time) as hour,count(order_id) from orders
group by hour(order_time);

--- Join relevant tables to find the category-wise distribution of pizzas

select category, count(name) from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day

select round(avg(quantity),0) from 
(select orders.order_date,sum(order_detials.quantity)  as quantity
from orders join order_detials
on orders.order_id=order_detials.order_id
group by orders.order_date) as  order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name,
order_detials.quantity* pizzas.price as revenue
from pizza_types join  pizzas
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_detials
on order_detials.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by revenue desc;

--- Calculate the percentage contribution of each pizza type to total revenue

select pizza_types.category,(sum(order_details.quantity* pizzas.price))pizza_types.category / (select round(sum(order_detials.quantity* pizzas.price),2) as total_sales 
from order_details join pizzas on pizzas.pizza_id=order_details.pizza_id))*100 as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id

group by pizza_types.category order by revenue desc;
