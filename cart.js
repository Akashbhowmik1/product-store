let cart = [];

function addToCart(productId) {
  const product = products.find(p => p.id === productId);
  if (!product) return;

  const cartItem = cart.find(item => item.id === productId);
  if (cartItem) {
    cartItem.quantity++;
  } else {
    cart.push({ ...product, quantity: 1 });
  }

  renderCart();
}

function renderCart() {
  const cartItems = document.getElementById('cartItems');
  const totalSpan = document.getElementById('total');

  cartItems.innerHTML = '';
  let total = 0;

  cart.forEach(item => {
    const li = document.createElement('li');
    li.textContent = `${item.name} x${item.quantity} - $${item.price * item.quantity}`;
    cartItems.appendChild(li);

    total += item.price * item.quantity;
  });

  totalSpan.textContent = total.toFixed(2);
}

function clearCart() {
  cart = [];
  renderCart();
}

function checkout() {
  if (cart.length === 0) {
    alert('Cart is empty!');
    return;
  }
  alert(`Thank you for your purchase! Total: $${cart.reduce((acc, item) => acc + item.price * item.quantity, 0).toFixed(2)}`);
  clearCart();
}
