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
  { id: 10, name: "VR Headset", price: 400, image: "https://images.unsplash.com/photo-1556228724-b1f8aabf26ef?auto=format&fit=crop&w=400&q=80" },
  { id: 11, name: "Gaming Mouse", price: 60, image: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=400&q=80" },
  { id: 12, name: "Mechanical Keyboard", price: 110, image: "https://images.unsplash.com/photo-1502672023488-70e25813eb80?auto=format&fit=crop&w=400&q=80" },
  { id: 13, name: "Laptop Stand", price: 45, image: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=400&q=80" },
  { id: 14, name: "USB-C Hub", price: 35, image: "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=400&q=80" },
  { id: 15, name: "Wireless Charger", price: 70, image: "https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=400&q=80" },
  { id: 16, name: "Smart Light Bulb", price: 25, image: "https://images.unsplash.com/photo-1556228724-b1f8aabf26ef?auto=format&fit=crop&w=400&q=80" },
  { id: 17, name: "Portable Projector", price: 350, image: "https://images.unsplash.com/photo-1502672023488-70e25813eb80?auto=format&fit=crop&w=400&q=80" },
  { id: 18, name: "Wireless Earbuds Case", price: 20, image: "https://images.unsplash.com/photo-1516707579370-ef4e62f7b7e8?auto=format&fit=crop&w=400&q=80" },
  { id: 19, name: "Electric Standing Desk", price: 300, image: "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=400&q=80" },
  { id: 20, name: "Smart Door Lock", price: 200, image: "https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=400&q=80" }
];

// --- Elements ---
const productList = document.getElementById("product-list");
const searchInput = document.getElementById("search-input");
const sortSelect = document.getElementById("sort-select");
const minPriceInput = document.getElementById("min-price");
const maxPriceInput = document.getElementById("max-price");
const filterPriceBtn = document.getElementById("filter-price-btn");
const clearFilterBtn = document.getElementById("clear-filter-btn");

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

// --- Event Listeners ---
searchInput.addEventListener("input", renderProducts);
sortSelect.addEventListener("change", renderProducts);
filterPriceBtn.addEventListener("click", renderProducts);
clearFilterBtn.addEventListener("click", () => {
  minPriceInput.value = "";
  maxPriceInput.value = "";
  renderProducts();
});

// --- Export for cart.js to use ---
window.products = products;
window.renderProducts = renderProducts;
