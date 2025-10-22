# LainOS Secure Messaging Service(LSMS) aka LESME(LainOS Ephemeral Secure Messaging Environment ) — XMPP over Tor

Welcome to the **LainOS Onion XMPP Service Guide** — a privacy‑focused, cross‑platform messaging framework using XMPP and the Tor network. For Lain fans(or anyone for that matter) who value privacy.
![LESME](https://gitlab.com/lainos/lainos-onion-xmpp-server-guide/-/raw/main/lesme_12.png?ref_type=heads)

![LESME](https://gitlab.com/lainos/lainos-onion-xmpp-server-guide/-/raw/main/lesme9.png?ref_type=heads)
---

## 🌐 What is this?

A private service for anyone, made easier with LainOS.

As the world get more draconian and takes erodes our rights away, using proprietary solutions seems to get more and more invasive by the day. People in certain countries were blocked from downloading LainOS, so in the last 3 days, I ported my vesme-avf project from debian 12 aarch64 to Archlinux x86_64 to integrate with LainOS, and give people more ways to connect easily despite heavy surveillance in their regions. If we're going to live in a cyberpunk dystopia, we need the appropriate tools.

This project implementation stems all the way back from my work fixing the Tor snowflake pluggable transport for QubesOS and Whonix. That experience spawned my other project 'vesme-avf' or VESME, and has finally been integrated with another of my more established projects, LainOS, to create 'LESME'. my work on whonix/qubes can be reviewed here: https://gitlab.com/amnesia1337/portfolio

[vesme-avf](https://github.com/amnesia1337/vesme-avf/tree/main)
[LainOS](https://github.com/The-LainOS-Project)

## LainOS XMPP Security Profile: A Technical Overview

This document summarizes the security level of the LainOS XMPP utility/setup, which combines XMPP, Tor, and GPG/Pass for highly hardened communication.


---

### Security Stack Breakdown

The LainOS approach relies on three synergistic components, each providing critical security layers:

| Component | Function | Security Layer | Security Level in this Context |
| :--- | :--- | :--- | :--- |
| **1. Tor Network Routing** | **Anonymity & Anti-Metadata** | Network Anonymity | **Excellent (Highest Available).** Traffic is bounced through relays, masking the user's real-world IP address and physical location. Using an `.onion` server hides the server's location as well. |
| **2. GPG / Pass Integration** | **Credential & Identity** | Cryptographic Key & Credential Management | **Excellent.** Stores the XMPP password in an encrypted **Pass** vault, secured by a personal **GPG key**. This prevents password exposure and reinforces the user's cryptographic identity. |
| **3. XMPP (with Onion Service)** | **Messaging Foundation** | Decentralization & Transport Encryption (TLS) | **Strong.** Provides a non-centralized, open standard platform. Using a hidden `.onion` address bypasses traditional, centralized Certificate Authority (CA) trust models. |

---

### Comparison to Industry Standards

The LainOS setup is fundamentally more resilient against certain attacks than common centralized messaging apps due to its design choices.

#### 1. Against Centralized Services (e.g., Signal, WhatsApp)

| Feature | LainOS XMPP (Hardened) | Signal/WhatsApp (Standard) |
| :--- | :--- | :--- |
| **Network Anonymity** | **Highest.** Mandatory routing through Tor. | **Low.** Uses clearnet connection, exposing user IP and device metadata. |
| **Metadata Protection** | **Excellent** (Tor prevents traffic analysis/logging). | **Good** (Proprietary "Sealed Sender" techniques), but connection metadata is still known to the service provider. |
| **Identity Anchor** | **GPG Key** (User-controlled, cryptographic). | **Phone Number** (Centralized, KYC-linked identity). |
| **Platform/Vendor Risk** | **You must trust the LainOS devs and the VPS provider** | **High** (Relies on a single, private, third-party entity). |
| **End-to-End Encryption** | OMEMO (Based on the Signal Protocol). | Signal Protocol. **Comparable.** |

#### 2. Against Standard XMPP Setups

The LainOS utility automates the integration of the most critical security extensions, which are often overlooked in a basic XMPP installation:

* **Standard XMPP:** Typically relies on basic client password storage and connects to a clearnet server, exposing the user's IP.
* **LainOS Utility:** **Enforces** the use of the **Tor Proxy** and integrates with the **GPG/Pass** credential system, eliminating the weakest links in most standard secure chat configurations.

### Summary

The LainOS utility elevates XMPP security beyond basic End-to-End Encryption (E2EE) by adding crucial layers of **anonymity (Tor)** and **cryptographic identity verification (GPG/Pass)**. This makes it suitable for environments where **metadata and identity protection** are considered equally or more important than message content protection alone.
XMPP Account Registration (Recommended Method)

Go here for profanity registration instructions: 

The easiest and most reliable method to register an account on the LainOS XMPP server is by combining the Another.im Android client with Orbot running in Power User mode to ensure Tor network access.

Prerequisites

go here for instructions  if you want pgp login: https://gitlab.com/lainos/lainos-secure-messaging-service

    Orbot: Installed and running. select check the 'power user mode' box in the settings to be able to torify individual apps, do not run in VPN mode, I recommend snowflake bridges for android.

        Crucial Step: You must manually Torify the app. Go to Orbot's options menu, select "Choose Apps," and make sure "Another.im" is selected to force its connection through the Tor network.

    Another.im: Installed from F-Droid (or Play Store).

Step-by-Step Registration

Step	Action	Details / Field Input
1.	Open the Another.im application.	
2.	Tap the three-dot menu (⋮) in the top-right corner.	
3.	Select Manage Accounts.	
4.	Tap the Plus button (⊕) to start the registration process.	This opens the registration screen.
5.	Fill the first field (JID)	Enter your desired XMPP address in the format: your_username@server.onion (e.g., neo@lainos.onion).

![registration screen](https://github.com/The-LainOS-Project/lainos-secure-messaging-service/blob/16a91097746c662dd3b9dfa8cefa9506fa7ade57/Screenshot_20251012-044944.PNG)

6.	Set Password	Provide a strong, unique password.
7.	Registration Checkbox	Crucially, ensure the "Register on server" box is checked.
8.	Hostname	Leave the "Hostname" field blank. Another.im will correctly infer the Tor Hidden Service address from your JID.
9.	Complete	Press the Confirm/Register button.

The client will now attempt to connect via Orbot and perform the In-Band Registration (IBR) with the LainOS XMPP server. Upon success, your new XMPP account will be ready for use.

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

Grayson Giles aka Amnesia PGP Fingerprint: 2B53 ECEF 5A47 ACF1 9A08 0E46 B2E5 012D 409A 7AFB


