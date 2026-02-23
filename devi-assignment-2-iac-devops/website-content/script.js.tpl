const API_URL = "${api_url}/messages";

async function submitMessage() {
  const message = document.getElementById("messageInput").value;

  await fetch(API_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ message })
  });

  loadMessages();
}

async function loadMessages() {
  const response = await fetch(API_URL);
  const data = await response.json();

  const list = document.getElementById("messages");
  list.innerHTML = "";

  data.forEach(item => {
    const li = document.createElement("li");
    li.textContent = item.message;
    list.appendChild(li);
  });
}

loadMessages();