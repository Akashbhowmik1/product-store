// Ecommerce Fullstack App - Main Code Structure

// Phase 1: React Router & Layout (Already implemented)
// Phase 2–6 follow below for complete feature integration using free APIs

// === Phase 2: Product Features (Free API) ===
// src/pages/HomePage.tsx (Product Grid + Filters via DummyJSON API)
import { Link } from 'react-router-dom';
import { useEffect, useState } from 'react';

const HomePage = () => {
  const [products, setProducts] = useState<any[]>([]);
  const [filter, setFilter] = useState({ category: '', price: 100 });

  useEffect(() => {
    fetch('https://dummyjson.com/products')
      .then(res => res.json())
      .then(data => setProducts(data.products));
  }, []);

  const filtered = products.filter(p =>
    (filter.category === '' || p.category === filter.category) &&
    p.price <= filter.price
  );

  const categories = Array.from(new Set(products.map(p => p.category)));

  return (
    <div>
      <h2>Products</h2>
      <div>
        Category:
        <select onChange={e => setFilter({ ...filter, category: e.target.value })}>
          <option value="">All</option>
          {categories.map(cat => (
            <option key={cat} value={cat}>{cat}</option>
          ))}
        </select>
        Max Price: 
        <input
          type="range"
          min="0"
          max="1000"
          value={filter.price}
          onChange={e => setFilter({ ...filter, price: Number(e.target.value) })}
        />
        ${filter.price}
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '1rem' }}>
        {filtered.map(p => (
          <Link key={p.id} to={`/product/${p.id}`}>
            <img src={p.thumbnail} alt={p.title} width="100" />
            <h4>{p.title}</h4>
            <p>${p.price}</p>
          </Link>
        ))}
      </div>
    </div>
  );
};
export default HomePage;

// src/pages/ProductDetail.tsx (Fetch Single Product)
import { useParams } from 'react-router-dom';
import { useEffect, useState } from 'react';

const ProductDetail = () => {
  const { id } = useParams();
  const [product, setProduct] = useState<any>(null);

  useEffect(() => {
    fetch(`https://dummyjson.com/products/${id}`)
      .then(res => res.json())
      .then(data => setProduct(data));
  }, [id]);

  if (!product) return <div>Loading...</div>;

  return (
    <div>
      <h2>{product.title}</h2>
      <img src={product.thumbnail} alt={product.title} width="200" />
      <p>{product.description}</p>
      <p>Category: {product.category}</p>
      <p>Price: ${product.price}</p>
      <p>Stock: {product.stock}</p>
    </div>
  );
};
export default ProductDetail;

// === Phase 3–6 remain same: switch static data to APIs when applicable ===
// Example APIs:
// - Auth: Firebase/Auth0
// - Cart/Wishlist: localStorage or Firebase
// - Checkout: Stripe test mode
// - Orders: Firestore
// - Emails: EmailJS
// - Contact: Formspree
// - Newsletter: Mailchimp embedded form

// Continue to implement CartContext, Auth, Checkout, etc. with live APIs
