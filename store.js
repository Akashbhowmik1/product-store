const products = [
  { id: 1, name: "Eco-friendly Water Bottle", price: 20 },
  { id: 2, name: "Wireless Earbuds", price: 60 },
  { id: 3, name: "Yoga Mat", price: 35 },
  { id: 4, name: "Smart Watch", price: 120 }
]

let cart = []

function getDynamicPrice(base) {
  const now = new Date()
  const hour = now.getHours()
  const day = now.getDay()

  let price = base

  if (day === 0 || day === 6) {
    price *= 0.85
  } else {
    if (hour >= 6 && hour < 12) {
      price *= 0.9
    } else if (hour >= 22 || hour < 6) {
      price *= 1.05
    }
  }
  return price.toFixed(2)
}

function renderProducts() {
  const list = document.getElementById('product-list')
  list.innerHTML = ''

  products.forEach(p => {
    const price = getDynamicPrice(p.price)
    const div = document.createElement('div')
    div.className = 'product'
    div.innerHTML = `
      <h3>${p.name}</h3>
      <p class="price">$${price}</p>
      <button onclick="addToCart(${p.id})">Add to Cart</button>
    `
    list.appendChild(div)
  })
}

function addToCart(id) {
  const product = products.find(p => p.id === id)
  if (!product) return

  const item = cart.find(c => c.id === id)
  if (item) {
    item.qty++
  } else {
    cart.push({ id: product.id, name: product.name, basePrice: product.price, qty: 1 })
  }
  renderCart()
}

function renderCart() {
  const cartEl = document.getElementById('cart-items')
  const totalEl = document.getElementById('cart-total')

  if (!cart.length) {
    cartEl.innerHTML = '<p>Cart is empty</p>'
    totalEl.textContent = ''
    return
  }

  let total = 0
  cartEl.innerHTML = ''

  cart.forEach(item => {
    const price = parseFloat(getDynamicPrice(item.basePrice))
    const itemTotal = price * item.qty
    total += itemTotal

    const div = document.createElement('div')
    div.className = 'cart-item'
    div.innerHTML = `<span>${item.name} (x${item.qty})</span><span>$${itemTotal.toFixed(2)}</span>`
    cartEl.appendChild(div)
  })

  totalEl.textContent = `Total: $${total.toFixed(2)}`
}

renderProducts()
