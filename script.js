const productList = document.getElementById("product-list");
const cartElement = document.getElementById("cart");
const totalPriceElement = document.getElementById("total-price");

let products = [];
let cart = [];

// Fetch products from Fake Store API
fetch("https://fakestoreapi.com/products")
  .then(res => res.json())
  .then(data => {
    products = data;
    renderProducts();
  })
  .catch(err => {
    productList.innerHTML = "<p>Error loading products.</p>";
    console.error(err);
  });

function renderProducts() {
  productList.innerHTML = "";

  products.forEach(product => {
    const div = document.createElement("div");
    div.className = "product";
    div.innerHTML = `
      <img src="${product.image}" alt="${product.title}" />
      <h3>${product.title}</h3>
      <p>$${product.price.toFixed(2)}</p>
      <button onclick="addToCart(${product.id})">Add to Cart</button>
    `;
    productList.appendChild(div);
  });
}

function addToCart(productId) {
  const item = cart.find(p => p.id === productId);
  if (item) {
    item.quantity += 1;
  } else {
    const product = products.find(p => p.id === productId);
    cart.push({ ...product, quantity: 1 });
  }
  renderCart();
}

function removeFromCart(productId) {
  cart = cart.filter(item => item.id !== productId);
  renderCart();
}

function changeQuantity(productId, amount) {
  const item = cart.find(p => p.id === productId);
  if (!item) return;

  item.quantity += amount;
  if (item.quantity <= 0) {
    removeFromCart(productId);
  }
  renderCart();
}

function renderCart() {
  cartElement.innerHTML = "";

  cart.forEach(item => {
    const div = document.createElement("div");
    div.className = "cart-item";
    div.innerHTML = `
      <img src="${item.image}" alt="${item.title}" />
      <h4>${item.title}</h4>
      <p>$${item.price.toFixed(2)} x ${item.quantity}</p>
      <div>
        <button onclick="changeQuantity(${item.id}, -1)">-</button>
        <button onclick="changeQuantity(${item.id}, 1)">+</button>
        <button onclick="removeFromCart(${item.id})">Remove</button>
      </div>
    `;
    cartElement.appendChild(div);
  });

  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
  totalPriceElement.textContent = `Total: $${total.toFixed(2)}`;
}
