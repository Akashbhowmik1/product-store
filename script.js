const productList = document.getElementById("product-list");
const cartElement = document.getElementById("cart");
const totalPriceElement = document.getElementById("total-price");

let products = [];
let cart = [];

// Show loading indicator while fetching products
productList.textContent = "Loading products...";

async function fetchProducts() {
  try {
    const res = await fetch("https://fakestoreapi.com/products");
    if (!res.ok) throw new Error("Failed to fetch products");
    products = await res.json();
    renderProducts();
  } catch (error) {
    productList.innerHTML = "<p>Error loading products.</p>";
    console.error(error);
  }
}

function renderProducts() {
  productList.innerHTML = "";
  const fragment = document.createDocumentFragment();

  products.forEach(({ id, image, title, price }) => {
    const div = document.createElement("div");
    div.className = "product";
    div.dataset.id = id;
    div.innerHTML = `
      <img src="${image}" alt="${title}" loading="lazy" />
      <h3>${title}</h3>
      <p>$${price.toFixed(2)}</p>
      <button class="add-to-cart">Add to Cart</button>
    `;
    fragment.appendChild(div);
  });

  productList.appendChild(fragment);
}

// Event delegation for product list buttons
productList.addEventListener("click", (e) => {
  if (e.target.classList.contains("add-to-cart")) {
    const productId = +e.target.closest(".product").dataset.id;
    addToCart(productId);
  }
});

function addToCart(productId) {
  const item = cart.find(p => p.id === productId);
  if (item) {
    item.quantity++;
  } else {
    const product = products.find(p => p.id === productId);
    if (product) cart.push({ ...product, quantity: 1 });
  }
  renderCart();
}

// Event delegation for cart buttons
cartElement.addEventListener("click", (e) => {
  const target = e.target;
  const cartItem = target.closest(".cart-item");
  if (!cartItem) return;

  const productId = +cartItem.dataset.id;

  if (target.classList.contains("remove")) {
    removeFromCart(productId);
  } else if (target.classList.contains("increment")) {
    changeQuantity(productId, 1);
  } else if (target.classList.contains("decrement")) {
    changeQuantity(productId, -1);
  }
});

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
  } else {
    renderCart();
  }
}

function renderCart() {
  cartElement.innerHTML = "";
  const fragment = document.createDocumentFragment();

  cart.forEach(({ id, image, title, price, quantity }) => {
    const div = document.createElement("div");
    div.className = "cart-item";
    div.dataset.id = id;
    div.innerHTML = `
      <img src="${image}" alt="${title}" loading="lazy" />
      <h4>${title}</h4>
      <p>$${price.toFixed(2)} x ${quantity}</p>
      <div>
        <button class="decrement">-</button>
        <button class="increment">+</button>
        <button class="remove">Remove</button>
      </div>
    `;
    fragment.appendChild(div);
  });

  cartElement.appendChild(fragment);

  const total = cart.reduce((sum, { price, quantity }) => sum + price * quantity, 0);
  totalPriceElement.textContent = `Total: $${total.toFixed(2)}`;
}

fetchProducts();
