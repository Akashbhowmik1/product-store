const productList = document.getElementById("product-list");
const cartElement = document.getElementById("cart");
const totalPriceElement = document.getElementById("total-price");
const searchInput = document.getElementById("search");
const categoryFilter = document.getElementById("category-filter");
const sortBySelect = document.getElementById("sort-by");
const clearCartBtn = document.getElementById("clear-cart");
const checkoutBtn = document.getElementById("checkout");

let products = [];
let filteredProducts = [];
let cart = JSON.parse(localStorage.getItem("cart")) || [];

async function fetchProducts() {
  try {
    const res = await fetch("https://fakestoreapi.com/products");
    if (!res.ok) throw new Error("Failed to fetch products");
    products = await res.json();
    populateCategories();
    filteredProducts = [...products];
    renderProducts();
    renderCart();
  } catch (error) {
    productList.innerHTML = "<p>Error loading products.</p>";
    console.error(error);
  }
}

function populateCategories() {
  const categories = [...new Set(products.map(p => p.category))];
  categories.forEach(cat => {
    const option = document.createElement("option");
    option.value = cat;
    option.textContent = capitalize(cat);
    categoryFilter.appendChild(option);
  });
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function renderProducts() {
  productList.innerHTML = "";
  const fragment = document.createDocumentFragment();

  filteredProducts.forEach(({ id, image, title, price }) => {
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
  saveCart();
  renderCart();
}

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
  saveCart();
  renderCart();
}

function changeQuantity(productId, amount) {
  const item = cart.find(p => p.id === productId);
  if (!item) return;
  item.quantity += amount;
  if (item.quantity <= 0) {
    removeFromCart(productId);
  } else {
    saveCart();
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

function saveCart() {
  localStorage.setItem("cart", JSON.stringify(cart));
}

searchInput.addEventListener("input", () => {
  filterAndSort();
});

categoryFilter.addEventListener("change", () => {
  filterAndSort();
});

sortBySelect.addEventListener("change", () => {
  filterAndSort();
});

function filterAndSort() {
  const searchTerm = searchInput.value.toLowerCase();
  const selectedCategory = categoryFilter.value;
  const sortBy = sortBySelect.value;

  filteredProducts = products.filter(product => {
    const matchesCategory = selectedCategory === "all" || product.category === selectedCategory;
    const matchesSearch = product.title.toLowerCase().includes(searchTerm);
    return matchesCategory && matchesSearch;
  });

  switch (sortBy) {
    case "price-asc":
      filteredProducts.sort((a, b) => a.price - b.price);
      break;
    case "price-desc":
      filteredProducts.sort((a, b) => b.price - a.price);
      break;
    case "title-asc":
      filteredProducts.sort((a, b) => a.title.localeCompare(b.title));
      break;
    case "title-desc":
      filteredProducts.sort((a, b) => b.title.localeCompare(a.title));
      break;
    default:
      break;
  }

  renderProducts();
}

// Clear Cart Button
clearCartBtn.addEventListener("click", () => {
  cart = [];
  saveCart();
  renderCart();
});

// Checkout Button (simple alert for demo)
checkoutBtn.addEventListener("click", () => {
  if (cart.length === 0) {
    alert("Your cart is empty.");
  } else {
    alert("Checkout process not implemented yet.");
  }
});

fetchProducts();
renderCart();
