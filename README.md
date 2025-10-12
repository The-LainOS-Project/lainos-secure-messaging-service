# LainOS Secure Messaging Server(LSMS) — XMPP over Tor

Welcome to the **LainOS Onion XMPP Server Guide** — a privacy‑focused, cross‑platform messaging framework using XMPP and the Tor network. For Lain fans(or anyone for that matter) who value privacy.
![LESME](https://gitlab.com/lainos/lainos-onion-xmpp-server-guide/-/raw/main/lesme_12.png?ref_type=heads)

![LESME](https://gitlab.com/lainos/lainos-onion-xmpp-server-guide/-/raw/main/lesme9.png?ref_type=heads)
---

## 🌐 What is this?

A private service for anyone, made easier with LainOS.

As the world get more draconian and takes erodes our rights away, using proprietary solutions seems to get more and more invasive by the day. People in certain countries were blocked from downloading LainOS, so in the last 3 days, I ported my vesme-avf project from debian 12 aarch64 to Archlinux x86_64 to integrate with LainOS, and give people more ways to connect easily despite heavy surveillance in their regions. If we're going to live in a cyberpunk dystopia, we need the tools.

This project implementation stems all the way back from my work fixing the Tor snowflake pluggable transport for QubesOS and Whonix. That experience spawned my other project 'vesme-avf' or VESME, and has finally been integrated with another of my more established projects, LainOS, to create 'LESME'.

[vesme-avf](https://github.com/amnesia1337/vesme-avf/tree/main)
[LainOS](https://github.com/The-LainOS-Project)



**LainOS Secure Messaging Server** is a private, anonymous chat system and service built on:

* **XMPP (Extensible Messaging and Presence Protocol)** — decentralized real‑time messaging (including group chat/MUC).
* **Tor (.onion hidden service)** — anonymizes traffic and hides both user IPs and server locations.
* **Profanity client** — a lightweight terminal XMPP client used in this guide.
* **PGP Integrated with GNU pass** — anonymized pgp keys for seamless user authentication and storage of plaintext passphrases using GNU `pass`.
* **TLS** — for server authentication and encryption in transit.
Together these provide encrypted, anonymous messaging with resistance to surveillance and censorship. For end‑to‑end confidentiality, enable client‑side encryption (OMEMO or PGP).

This project is part of the [vesme‑avf repo](https://gitlab.com/amnesia1337/vesme-avf) and integrates secure comms into LainOS. [vesme-avf GitHub](https://github.com/amnesia1337/vesme-avf/tree/main)

---

## 🔐 Server Details(PGP signed at bottom of page)

* **My XMPP JID (example):**
  `amnesia1337@glcuf4hcwbm3lt6grg7jfwwus7sqpuojozfsnbzzcsf7vbm2jcfqckid.onion`

* **Server Address:**
  `glcuf4hcwbm3lt6grg7jfwwus7sqpuojozfsnbzzcsf7vbm2jcfqckid.onion`

* **LainOS Chatroom (MUC):**
  `private-chat-c75bebbc-50f3-447d-811f-41f83de11811@conference.glcuf4hcwbm3lt6grg7jfwwus7sqpuojozfsnbzzcsf7vbm2jcfqckid.onion`

* **Warning:** When you enter the chatroom name to join it or when copying and pasting it, use profanity in full screen, just make sure it's one line.

---

## 🧰 Prerequisites(LainOS has them)

* `tor` (configured with **obfs4** bridges on LainOS)
* `torsocks` tunnel applications throught the Tor network
* `profanity` XMPP client
* `KeePassXC` (recommended) to store credentials safely
* `pass` secondary credential management layer
---

## 🚀 How to Get Started

### 1. Start Tor with obfs4 support

```bash
sudo systemctl start tor
sudo systemctl status tor   # confirm it bootstraps to 100%
# optional logs: sudo journalctl -u tor -f
```

### 2. Launch Profanity via Tor

```bash
torsocks profanity
```

### 3. Register a new XMPP account

In the profanity prompt:

```profanity
/register yourusername glcuf4hcwbm3lt6grg7jfwwus7sqpuojozfsnbzzcsf7vbm2jcfqckid.onion
```

* Enter your password **twice**.
* **Password rules (server):** uppercase, lowercase and numbers only — **no special characters**.
  (Special characters are rejected by the server and/or may be interpreted by the terminal.)
* When asked about TLS:

```profanity
/tls allow
```

* Save your preferences:

```profanity
/save
```
 Then exit profanity with `/quit`.

> 🔐 Store your username + password in KeePassXC.

---

### 4. Run the installation script (optional)

To install the framework:

```bash
bash LainOS-Secure-messaging-Server.sh
```

* **Important:** The script will prompt for a **PGP key password first**, and after installation you will be prompted for it each time you connect to the server, you can make it convenient as entering a pin, but generate your xmpp account passphrase using a KeePass with special characters disabled.
  **Do not include special characters** in that PGP password — the terminal can interpret them as shell syntax (which will break the prompt). Use only uppercase, lowercase, and numbers to be safe.
* Use KeePassXC to paste any required credentials into prompts.

---


### 5. Reconnect with your account

Exit profanity, reconnect with:

```bash
torsocks profanity -a yourusername@glcuf4hcwbm3lt6grg7jfwwus7sqpuojozfsnbzzcsf7vbm2jcfqckid.onion
```

Enter your PGP passphrase, accept the certificate when prompted using the command `/tls allow` in profanity.

---

### 6. Join the official LainOS secure and private chatroom

From within profanity(make sure this is all one line, in gui XMPP clients this is less of a problem):

```profanity
/join private-chat-c75bebbc-50f3-447d-811f-41f83de11811@conference.glcuf4hcwbm3lt6grg7jfwwus7sqpuojozfsnbzzcsf7vbm2jcfqckid.onion
```

---

## ✅ Tips & Best Practices

* **Store credentials in KeePassXC**, never plaintext.
* **Enable OMEMO or PGP** encryption where supported.
* Always run XMPP clients through `torsocks` (or configure a Tor SOCKS proxy).
* Avoid special characters in passwords asked by the installer/script or the terminal (PGP password is asked first by the installer).
* Keep LainOS, Tor, and clients updated. Harden your device and operational practices.

---

## 🛠 Troubleshooting

* **Tor not at 100% / connection issues:**

  ```bash
  sudo journalctl -u tor -f
  ```
* **`torsocks` missing:** install via package manager.
* **Profanity certificate prompts:** inspect fingerprint before accepting.
* **Registration/connect fails:** ensure Tor is running, `torsocks` is used, and `.onion` hostnames are exact.

---

## 🧪 Related Project

Main repo: 👉 [vesme‑avf GitLab Repo](https://gitlab.com/amnesia1337/vesme-avf)

---

Stay secure. Stay private. Stay wired.
*— amnesia1337*

---

# [**PGP signed Server info**](https://pixeldrain.com/d/YDPhuKvf/LainOS-Secure-Messaging-Server-Info-Signed-Message.txt)

Amnesia PGP Fingerprint: 2B53 ECEF 5A47 ACF1 9A08 0E46 B2E5 012D 409A 7AFB


