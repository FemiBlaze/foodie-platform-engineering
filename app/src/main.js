import "./styles.css";

const users = [
  { name: "Jane", username: "jane", password: "jane123" },
  { name: "Ken", username: "ken", password: "ken123" },
  { name: "Fredd", username: "fredd", password: "fredd123" },
];

const restaurants = [
  {
    name: "Burger Barn",
    eta: "15-20 min",
    menu: ["Cheese Burger", "Double Patty Burger", "Fries", "Chicken Nuggets"],
  },
  {
    name: "Crunchy Bites",
    eta: "20-25 min",
    menu: ["Fried Chicken", "Spicy Wings", "Mozzarella Sticks", "Coleslaw"],
  },
  {
    name: "Pizza Hub",
    eta: "25-30 min",
    menu: ["Pepperoni Pizza", "BBQ Chicken Pizza", "Garlic Bread", "Potato Wedges"],
  },
  {
    name: "Taco Rush",
    eta: "18-24 min",
    menu: ["Beef Taco", "Chicken Burrito", "Nachos", "Loaded Fries"],
  },
  {
    name: "Hotdog Corner",
    eta: "12-18 min",
    menu: ["Classic Hotdog", "Chili Dog", "Onion Rings", "Soda"],
  },
  {
    name: "Wrap City",
    eta: "16-22 min",
    menu: ["Chicken Wrap", "Beef Shawarma", "Falafel Wrap", "Sweet Potato Fries"],
  },
  {
    name: "Grill Express",
    eta: "20-28 min",
    menu: ["Grilled Chicken Sandwich", "Beef Burger", "BBQ Wings", "Milkshake"],
  },
  {
    name: "Snack Station",
    eta: "10-15 min",
    menu: ["Sausage Roll", "Meat Pie", "Fish Burger", "Chips"],
  },
  {
    name: "Street Feast",
    eta: "22-27 min",
    menu: ["Club Sandwich", "Chicken Burger", "Popcorn Chicken", "Iced Tea"],
  },
  {
    name: "Fast Track Diner",
    eta: "14-20 min",
    menu: ["Zinger Burger", "Crispy Chicken Wrap", "French Fries", "Donuts"],
  },
];

const app = document.querySelector("#app");

function renderLogin() {
  app.innerHTML = `
    <main class="app-shell">
      <section class="hero-panel">
        <div class="brand-mark">F</div>
        <p class="eyebrow">Food delivery app</p>
        <h1>Foodie</h1>
        <p class="hero-copy">
          A simple login interface for your DevOps project demo. Use any of the
          hardcoded accounts to sign in.
        </p>

        <div class="credential-board">
          <h2>Demo Users</h2>
          ${users
            .map(
              (user) => `
                <div class="user-card">
                  <span class="user-name">${user.name}</span>
                  <span>Username: <strong>${user.username}</strong></span>
                  <span>Password: <strong>${user.password}</strong></span>
                </div>
              `
            )
            .join("")}
        </div>
      </section>

      <section class="login-panel">
        <div class="login-card">
          <p class="card-label">Account Access</p>
          <h2>Login to Foodie</h2>
          <p class="card-copy">
            Enter one of the listed usernames and passwords to continue.
          </p>

          <form id="loginForm" class="login-form">
            <label for="username">Username</label>
            <input
              id="username"
              name="username"
              type="text"
              placeholder="Enter username"
              autocomplete="username"
              required
            />

            <label for="password">Password</label>
            <input
              id="password"
              name="password"
              type="password"
              placeholder="Enter password"
              autocomplete="current-password"
              required
            />

            <button type="submit">Sign In</button>
          </form>

          <p id="message" class="message" aria-live="polite"></p>
        </div>
      </section>
    </main>
  `;

  const form = document.querySelector("#loginForm");
  const message = document.querySelector("#message");

  form.addEventListener("submit", (event) => {
    event.preventDefault();

    const formData = new FormData(form);
    const username = String(formData.get("username") || "").trim().toLowerCase();
    const password = String(formData.get("password") || "").trim();

    const matchedUser = users.find(
      (user) => user.username === username && user.password === password
    );

    if (matchedUser) {
      renderLandingPage(matchedUser);
      return;
    }

    message.textContent =
      "Invalid username or password. Use one of the demo accounts.";
    message.className = "message error";
  });
}

function renderLandingPage(user) {
  app.innerHTML = `
    <main class="dashboard-shell">
      <section class="dashboard-hero">
        <div>
          <p class="eyebrow">Welcome back</p>
          <h1 class="dashboard-title">Hello, ${user.name}</h1>
          <p class="hero-copy">
            Explore restaurants on Foodie and check out a fast-food menu for each one.
          </p>
        </div>
        <button id="logoutButton" class="logout-button" type="button">Log Out</button>
      </section>

      <section class="stats-panel">
        <div class="stat-card">
          <span class="stat-value">${restaurants.length}</span>
          <span class="stat-label">Restaurants</span>
        </div>
        <div class="stat-card">
          <span class="stat-value">40+</span>
          <span class="stat-label">Fast-food items</span>
        </div>
        <div class="stat-card">
          <span class="stat-value">12-30 min</span>
          <span class="stat-label">Delivery range</span>
        </div>
      </section>

      <section class="restaurant-section">
        <div class="section-heading">
          <p class="eyebrow">Landing page</p>
          <h2>Available Restaurants</h2>
        </div>

        <div class="restaurant-grid">
          ${restaurants
            .map(
              (restaurant, index) => `
                <article class="restaurant-card">
                  <div class="restaurant-top">
                    <span class="restaurant-badge">#${index + 1}</span>
                    <span class="restaurant-eta">${restaurant.eta}</span>
                  </div>
                  <h3>${restaurant.name}</h3>
                  <p class="restaurant-copy">Fast food menu</p>
                  <ul class="menu-list">
                    ${restaurant.menu
                      .map((item) => `<li>${item}</li>`)
                      .join("")}
                  </ul>
                </article>
              `
            )
            .join("")}
        </div>
      </section>
    </main>
  `;

  const logoutButton = document.querySelector("#logoutButton");
  logoutButton.addEventListener("click", renderLogin);
}

renderLogin();
