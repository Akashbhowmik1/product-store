// === Cart Data ===
let cart = JSON.parse(localStorage.getItem("cart")) || {};

// --- Elements ---
const cartItemsContainer = document.getElementById("cart-items");
const cartTotalEl = document.getElementById("cart-total");
const cartCountEl = document.getElementById("cart-count");
const toastEl = document.getElementById("toast");
const clearCartBtn = document.getElementById("clear-cart-btn");

// --- Add to Cart ---
function addToCart(id) {
  if (cart[id]) {
    cart[id].qty++;
  } else {
    const prod = products.find(p => p.id === id);
    cart[id] = { ...prod, qty: 1 };
  }
  saveCart();
  renderCart();
  showToast("Added to cart!");
}

// --- Remove from Cart ---
function removeFromCart(id) {
  if (cart[id]) {
    cart[id].qty--;
    if (cart[id].qty <= 0) delete cart[id];
    saveCart();
    renderCart();
    showToast("Removed one item!");
  }
}

// --- Clear Cart ---
function clearCart() {
  cart = {};
  saveCart();
  renderCart();
  showToast("Cart cleared!");
}

// --- Save Cart to localStorage ---
function saveCart() {
  localStorage.setItem("cart", JSON.stringify(cart));
}

// --- Render Cart Items ---
function renderCart() {
  cartItemsContainer.innerHTML = "";
  const items = Object.values(cart);

  if (items.length === 0) {
    cartItemsContainer.innerHTML = "<p>Your cart is empty.</p>";
    cartTotalEl.textContent = "";
    cartCountEl.textContent = "0";
    return;
  }

  let totalQty = 0;
  let totalPrice = 0;

  items.forEach(item => {
    totalQty += item.qty;
    totalPrice += item.price * item.qty;

    const itemEl = document.createElement("div");
    itemEl.className = "cart-item";
    itemEl.innerHTML = `
      <span>${item.name} (x${item.qty})</span>
      <span>
        $${(item.price * item.qty).toFixed(2)}
        <button title="Remove one" data-id="${item.id}">&times;</button>
      </span>
    `;
    cartItemsContainer.appendChild(itemEl);

    itemEl.querySelector("button").addEventListener("click", () => {
      removeFromCart(item.id);
    });
  });

  cartTotalEl.textContent = `Total: $${totalPrice.toFixed(2)}`;
  cartCountEl.textContent = totalQty.toString();
}

// --- Toast ---
function showToast(msg) {
  toastEl.textContent = msg;
  toastEl.style.opacity = "1";
  setTimeout(() => {
    toastEl.style.opacity = "0";
  }, 2000);
}

// --- Events ---
clearCartBtn.addEventListener("click", () => {
  if (confirm("Are you sure you want to clear the cart?")) clearCart();
});

// --- Init ---
renderCart();
renderProducts(); // from products.js
