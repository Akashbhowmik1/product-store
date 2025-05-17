// === Product Data ===
const products = [
  { id: 1, name: "Wireless Headphones", price: 120, image: "https://images.unsplash.com/photo-1516707579370-ef4e62f7b7e8?auto=format&fit=crop&w=400&q=80" },
  { id: 2, name: "Smart Watch", price: 250, image: "https://images.unsplash.com/photo-1509395176047-4a66953fd231?auto=format&fit=crop&w=400&q=80" },
  { id: 3, name: "Bluetooth Speaker", price: 75, image: "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=400&q=80" },
  { id: 4, name: "Fitness Tracker", price: 95, image: "https://images.unsplash.com/photo-1549924231-f129b911e442?auto=format&fit=crop&w=400&q=80" },
  { id: 5, name: "Portable Charger", price: 50, image: "https://images.unsplash.com/photo-1523475496153-3d6ccf9f3a39?auto=format&fit=crop&w=400&q=80" },
  { id: 6, name: "Noise Cancelling Earbuds", price: 180, image: "https://images.unsplash.com/photo-1565182999561-c2df5e416801?auto=format&fit=crop&w=400&q=80" },
  { id: 7, name: "Action Camera", price: 320, image: "https://images.unsplash.com/photo-1502920514311-65e73d86f7a8?auto=format&fit=crop&w=400&q=80" },
  { id: 8, name: "E-reader", price: 140, image: "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=400&q=80" },
  { id: 9, name: "Smartphone Gimbal", price: 200, image: "https://images.unsplash.com/photo-1506719040635-7e70d8a569c3?auto=format&fit=crop&w=400&q=80" },
  { id: 10, name: "VR Headset", price: 400, image: "https://images.unsplash.com/photo-1556228724-b1f8aabf26ef?auto=format&fit=crop&w=400&q=80" }
];

// --- DOM Elements ---
const productList = document.getElementById("product-list");
const searchInput = document.getElementById("search-input");
const sortSelect = document.getElementById("sort-select");
const minPriceInput = document.getElementById("min-price");
const maxPriceInput = document.getElementById("max-price");
const filterPriceBtn = document.getElementById("filter-price-btn");
const clearFilterBtn = document.getElementById("clear-filter-btn");
const cartList = document.getElementById("cart-list");
const cartTotal = document.getElementById("cart-total");

// --- Cart Data ---
const cart = [];

// --- Render Products ---
function renderProducts() {
  const searchTerm = searchInput.value.trim().toLowerCase();
  const sortValue = sortSelect.value;
  const minPrice = parseFloat(minPriceInput.value);
  const maxPrice = parseFloat(maxPriceInput.value);

  let filtered = products.filter(p => p.name.toLowerCase().includes(searchTerm));
  if (!isNaN(minPrice)) filtered = filtered.filter(p => p.price >= minPrice);
  if (!isNaN(maxPrice)) filtered = filtered.filter(p => p.price <= maxPrice);

  if (sortValue === "price-asc") filtered.sort((a, b) => a.price - b.price);
  if (sortValue === "price-desc") filtered.sort((a, b) => b.price - a.price);

  productList.innerHTML = "";

  if (filtered.length === 0) {
    productList.innerHTML = "<p>No products found.</p>";
    return;
  }

  filtered.forEach(product => {
    const prodEl = document.createElement("div");
    prodEl.className = "product";
    prodEl.innerHTML = `
      <img src="${product.image}" alt="${product.name}" loading="lazy" />
      <h3>${product.name}</h3>
      <div class="price">$${product.price.toFixed(2)}</div>
      <button data-id="${product.id}">Add to Cart</button>
    `;
    productList.appendChild(prodEl);

    prodEl.querySelector("button").addEventListener("click", () => {
      addToCart(product.id);
    });
  });
}

// --- Add to Cart ---
function addToCart(productId) {
  const item = cart.find(c => c.id === productId);
  if (item) {
    item.qty++;
  } else {
    const product = products.find(p => p.id === productId);
    cart.push({ ...product, qty: 1 });
  }
  renderCart();
}

// --- Remove from Cart ---
function removeFromCart(productId) {
  const index = cart.findIndex(c => c.id === productId);
  if (index !== -1) {
    cart.splice(index, 1);
    renderCart();
  }
}

// --- Change Quantity ---
function changeQuantity(productId, change) {
  const item = cart.find(c => c.id === productId);
  if (item) {
    item.qty += change;
    if (item.qty <= 0) {
      removeFromCart(productId);
    }
    renderCart();
  }
}

// --- Render Cart ---
function renderCart() {
  cartList.innerHTML = "";
  let total = 0;

  cart.forEach(item => {
    const itemEl = document.createElement("li");
    itemEl.innerHTML = `
      ${item.name} x ${item.qty} = $${(item.price * item.qty).toFixed(2)}
      <button onclick="changeQuantity(${item.id}, 1)">+</button>
      <button onclick="changeQuantity(${item.id}, -1)">-</button>
      <button onclick="removeFromCart(${item.id})">Remove</button>
    `;
    cartList.appendChild(itemEl);
    total += item.price * item.qty;
  });

  cartTotal.textContent = `Total: $${total.toFixed(2)}`;
}

// --- Event Listeners ---
searchInput.addEventListener("input", renderProducts);
sortSelect.addEventListener("change", renderProducts);
filterPriceBtn.addEventListener("click", renderProducts);
clearFilterBtn.addEventListener("click", () => {
  minPriceInput.value = "";
  maxPriceInput.value = "";
  renderProducts();
});

// --- Initial Render ---
window.onload = renderProducts;

// --- Expose to global for onclick handlers ---
window.changeQuantity = changeQuantity;
window.removeFromCart = removeFromCart;
