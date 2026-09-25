<div align="center">

# 🛠️ SkillsKart

### Your Skill. Your Shop. Your Say.

A cooperative-owned digital marketplace connecting **consumers** with verified **gig workers, artisans, businesses, and community organizations** — governed end-to-end by India's Labour Cooperative Federations and Societies.

Built for **SIH26089 — Cooperative Gig Services Platform for Household & Community Services**

<br/>

![Last Commit](https://img.shields.io/github/last-commit/ansh-kukreja/SkillsKart?style=flat-square&color=B45309&label=last%20commit)
![Repo Size](https://img.shields.io/github/repo-size/ansh-kukreja/SkillsKart?style=flat-square&color=B45309&label=repo%20size)
![Top Language](https://img.shields.io/github/languages/top/ansh-kukreja/SkillsKart?style=flat-square&color=B45309&label=top%20language)
![Languages](https://img.shields.io/github/languages/count/ansh-kukreja/SkillsKart?style=flat-square&color=B45309&label=languages)

![Status](https://img.shields.io/badge/status-prototype-orange?style=flat-square)
![License](https://img.shields.io/badge/license-none%20yet-lightgrey?style=flat-square)
![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?style=flat-square&logo=flutter&logoColor=white)
![React](https://img.shields.io/badge/React-18-61DAFB?style=flat-square&logo=react&logoColor=black)
![TypeScript](https://img.shields.io/badge/TypeScript-Vite-3178C6?style=flat-square&logo=typescript&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=flat-square&logo=tailwind-css&logoColor=white)

<br/>

**Jump straight to an app** — presented in the order a real user meets them: **consumer → worker → cooperative**

[![Consumer App](https://img.shields.io/badge/📱_Consumer_App-FF6B35?style=for-the-badge&logoColor=white)](#-consumer-app)
[![Worker App](https://img.shields.io/badge/👷_Worker_App-1E3A15?style=for-the-badge&logoColor=white)](#-worker-app)
[![Cooperative Web Console](https://img.shields.io/badge/🌐_Cooperative_Web_Console-0284C7?style=for-the-badge&logoColor=white)](#-website--cooperative-web-console)

</div>

---

## 📚 Table of Contents

- [What is SkillsKart?](#-what-is-skillskart)
- [Problem We Solve](#-problem-we-solve)
- [Our Solution](#-our-solution)
- [SkillsKart Ecosystem](#-skillskart-ecosystem)
- [User Roles](#-user-roles)
- [📱 Consumer App](#-consumer-app)
- [👷 Worker App](#-worker-app)
- [🌐 Website — Cooperative Web Console](#-website--cooperative-web-console)
- [Flow Diagrams](#-flow-diagrams)
  - [Consumer Flow](#-consumer-flow)
  - [Worker Flow](#-worker-flow)
  - [Cooperative Flow](#-cooperative-flow)
- [System Architecture](#-system-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Environment Variables](#-environment-variables)
- [Running the Project](#-running-the-project)
- [Testing](#-testing)
- [Security](#-security)
- [Future Scope](#-future-scope)
- [Contribution](#-contribution)
- [License](#-license)
- [Team](#-team)

---

## 🌟 What is SkillsKart?

Millions of skilled workers in India — electricians, plumbers, carpenters, painters, domestic helpers, caregivers, drivers, gardeners, cleaners, and technicians — work in the informal economy with no verified digital identity, no fair-wage guarantees, and no organized route to steady demand. Consumers, meanwhile, have no reliable way to find and trust these workers.

SkillsKart closes that gap with a **consumer-facing marketplace** on one side, a **worker/partner app** on the other, and **Labour Cooperative Federations and Societies** — not a single private aggregator — governing verification, pricing, and welfare in between.

## 🎯 Problem We Solve

- Consumers have no easy way to **discover and book** verified local service providers, hand-made products, part-time jobs, or community initiatives in one place.
- Skilled workers lack a **verified, portable digital profile** that proves their trade and credibility.
- There is no structured system for **fair, transparent pricing** — wages are often set unilaterally by demand-side platforms.
- Worker welfare schemes (insurance, social security) exist on paper but are **disconnected from where workers actually get discovered and hired**.
- Cooperative federations and societies — the real-world bodies meant to protect workers — have **no digital tooling** to onboard, verify, and govern their members at scale.

## 💡 Our Solution

SkillsKart is split into three purpose-built applications, presented here in the order a real user actually travels through the ecosystem:

| # | App | Built for | Role |
|---|---|---|---|
| 1 | **📱 Consumer App** | Households, businesses | Discover and book services, browse jobs, shop artisan products, and take part in community programs |
| 2 | **👷 Worker App** | Gig workers, product sellers, business owners, community organizations | A single "Partner Portal" where each of these four roles gets a dedicated workspace |
| 3 | **🌐 Cooperative Web Console** | Cooperative Federations & Societies | Govern the network — approve members, set rate cards, monitor demand, and respond to emergencies |

---

## 🏗️ SkillsKart Ecosystem

```mermaid
flowchart TB
    subgraph Demand["📱 Consumer App"]
        NU["Normal User"]
        EU["Commercial / Enterprise User"]
    end

    subgraph Partners["👷 Worker App — Partner Portal"]
        GW["Gig Worker"]
        PS["Product Seller"]
        BO["Business Owner"]
        CO["Community Org"]
    end

    subgraph Governance["🌐 Cooperative Web Console"]
        SOC["Cooperative Society\n(Primary Worker Collective)"]
        FED["Cooperative Federation\n(State / Regional Apex)"]
    end

    NU -- "books a service" --> GW
    NU -- "orders a product" --> PS
    NU -- "applies to a job" --> BO
    NU -- "joins an initiative" --> CO
    NU -- "raises Emergency SOS" --> SOC
    EU -- "bulk requisition" --> FED

    GW -- "verified & governed by" --> SOC
    PS -- "verified & governed by" --> SOC
    SOC --> FED
```

> **Reading note:** this diagram — and the rest of this README — follows the **consumer's journey first**. In the real onboarding sequence, a worker must already be verified by a Cooperative Society before a consumer ever sees them; the Cooperative Web Console is what makes that verification possible behind the scenes.

## 👥 User Roles

### 🧑‍💼 Consumer
Two account types, chosen at login:
- **Normal User** — books individual services, applies to jobs, shops artisan products, and joins community initiatives.
- **Commercial / Enterprise User** — everything a Normal User can do, plus **bulk service requisitions**: submitting multi-worker, multi-month contract requests (trade, headcount, duration, site, SLA tier) that are routed to a Cooperative Federation for review and worker deployment.

### 👷 Gig Worker
Verifies their trade skill, gets listed under a Cooperative Society, and receives local service bookings through the Consumer App.

### 🛍️ Product Seller
Lists hand-crafted/artisan products with photos and pricing for consumers to browse and order through the Consumer App's Craft Store.

### 🏢 Business Owner
Posts local, part-time job openings that Normal Users can browse and apply to from the Consumer App's Jobs tab.

### 🤝 Community Organization
Posts community initiatives — such as blood donation camps and health drives — that consumers can discover and join through the Community Services section.

---

## 📱 Consumer App

*Flutter app · role-based login (Normal / Enterprise) · 4-tab bottom navigation*

**Flow:** `Login (choose account type)` → `Services / Jobs / Craft Store / Community (bottom nav)` → `Explore & Select` → `Book / Apply / Order / Join`

| Tab | What it offers |
|---|---|
| **Services** | Browse trades (electricians, plumbers, carpenters, painters, domestic helpers, caregivers, drivers, gardeners, cleaners) with ratings, starting prices, and guild-certified specialists to select and book |
| **Jobs** | Browse and apply to part-time/local jobs posted by Business Owners |
| **Craft Store** | Browse and order hand-crafted products listed by Product Sellers |
| **Community Services** | Discover and join community drives (e.g. blood donation camps) posted by Community Organizations |

<details>
<summary><b>Enterprise-only flow — Bulk Booking</b></summary>
<br/>

Commercial Users get an additional **Bulk Booking** sheet where they specify trade, worker count, contract duration, shift, site location, and SLA tier. The request is tracked through a federation-review lifecycle:

`Submitted → Federation Review → Matchmaker Assigned → Approved → Deployed`

</details>

## 👷 Worker App

*Flutter app · "Partner Portal" · single role-selection screen routes to one of four dedicated workspaces*

On launch, the Worker App presents a role picker — there is no separate login for each role; a partner simply selects their workspace:

1. **Gig Worker** — verify skills, view bookings received from consumers
2. **Product Seller** — list products with price and photos, manage orders
3. **Business Owner** — post local job openings for consumers to apply to
4. **Community Organization** — post community events (health camps, drives, etc.)

Each of the four roles opens into its own dedicated main screen with a role-appropriate bottom navigation, and a role-switch sheet lets a partner jump between workspaces without a full re-login.

## 🌐 Website — Cooperative Web Console

*React + TypeScript + Vite + Tailwind CSS single-page app*

The website is **not a public marketing site** — it is the operational console used by **Cooperative Federations and Societies** to govern the network. Login offers two role types, **Cooperative Federation** (state/regional apex) and **Cooperative Society** (primary worker collective), each with a one-click demo account for instant access.

| Screen | Purpose |
|---|---|
| **Dashboard** | Network-wide overview for the logged-in federation/society |
| **Hierarchy Node** | View the federation → society → worker organizational structure |
| **Worker Registry** | Directory of verified, onboarded workers under this node |
| **Emergency SOS** | Live queue of SOS alerts raised from the Consumer App, routed here for dispatch |
| **Trade Rate Cards** | Set and cap service pricing (floor/ceiling) per trade |
| **Demand Forecast** | View projected demand and workforce allocation by area/trade |
| **Bulk Tenders** | Review and action enterprise bulk-service requisitions |
| **Audit Ledger** | Governance/audit trail of administrative actions |
| **Admin Profile** | Manage the logged-in administrator's account |

---

## 🔄 Flow Diagrams

Three detailed flows — one per app, in the same consumer → worker → cooperative order as the rest of this README — followed by how they connect end to end.

### 📱 Consumer Flow

```mermaid
flowchart TD
    A[Open Consumer App] --> B{Login: choose account type}
    B -->|Normal User| C[Land on Services tab]
    B -->|Enterprise User| C
    C --> D{Pick a bottom-nav tab}
    D -->|Services| E["Browse trades\nrating, starting price"]
    E --> F[Select a specialist]
    F --> G[Book service]
    G --> Q[Rate & give feedback]
    D -->|Jobs| H[Browse job board]
    H --> I["View job details\npay & hours"]
    I --> J[Apply to job]
    D -->|Craft Store| K[Browse product catalog]
    K --> L["View product\nphotos & price"]
    L --> M[Order & pay]
    D -->|Community| N[Browse community events]
    N --> O[View event info]
    O --> P[Confirm & join]
    C -.Enterprise User only.-> R[Open Bulk Booking sheet]
    R --> S["Specify trade, worker count,\nduration, site, SLA tier"]
    S --> T["Submitted → Federation Review →\nMatchmaker Assigned → Approved → Deployed"]
```

### 👷 Worker Flow

```mermaid
flowchart TD
    A[Open Worker App] --> B["Role Selection screen\n(Partner Portal)"]
    B -->|Gig Worker| C[Gig Worker home]
    C --> D["Verify Skill tab\nKYC & Skill verification"]
    D --> E["'SkillsKart Guild Certified' badge"]
    E --> F[Receive bookings from Consumer App]
    F --> G[Complete the job]
    G --> H[Payout credited to SkillsKart Wallet]
    B -->|Product Seller| I[Product Seller home]
    I --> J["List products\nprice & photos"]
    J --> K[Manage incoming orders]
    B -->|Business Owner| L[Business Owner home]
    L --> M[Post a local job]
    M --> N[Review applicants]
    B -->|Community Org| O[Community Org home]
    O --> P[Post a community event]
    P --> S2[Track participation]
    C -.-> RS[Role-switch sheet]
    I -.-> RS
    L -.-> RS
    O -.-> RS
    RS -.-> B
```

### 🌐 Cooperative Flow

```mermaid
flowchart TD
    A[Open Cooperative Web Console] --> B{Login: choose role}
    B -->|Cooperative Federation| C[Federation Dashboard]
    B -->|Cooperative Society| D[Society Dashboard]
    C --> E[Hierarchy Node screen]
    E --> F["Add Federation Node /\nAdd Primary Society"]
    D --> G[Worker Registry]
    G --> H["Add Worker\nname, phone, experience, zone"]
    H --> I[Complete Enrolment]
    I --> J["Auto: e-Shram verification +\nGroup Health Insurance activated"]
    C --> K["Trade Rate Cards\nset price floor / ceiling"]
    C --> L[Demand Forecast]
    C --> M[Bulk Tenders]
    M --> N["Pending Review → Team Proposed → Confirmed"]
    D --> O[Emergency SOS queue]
    O --> P["Open → Dispatched → Resolved"]
    C --> QQ[Audit Ledger]
    D --> QQ
```

> Enrolling a worker on the Society Dashboard is wired to automatically generate a cooperative member identity and activate their e-Shram and Group Health Insurance status — this is implemented as mock state (`AppContext`), not a live integration with government portals.

### 🔗 How the three flows connect

```mermaid
flowchart TB
    A["📱 Consumer App\nDiscover a service, product, job, or event"] --> B["Book / Apply / Order / Join"]
    B --> C["👷 Worker App\nGig Worker, Product Seller, Business Owner\nor Community Org fulfils the request"]
    C --> D["🌐 Cooperative Web Console\nFederation & Society verify, price, and govern"]
    A --> E["Enterprise User submits a\nBulk Requisition"]
    E --> D
    B --> F["Emergency SOS raised"]
    F --> D
```

- **Emergency SOS:** when a consumer raises an SOS from the Consumer App, it is designed to surface directly in the Cooperative Web Console's Emergency SOS queue (`Open → Dispatched → Resolved`) so the responsible society/federation can dispatch a worker quickly.
- **Bulk requests:** enterprise/commercial consumers needing multiple workers (e.g. for a construction site or institution) submit a requisition that a Cooperative Federation reviews and approves for deployment. Note the Consumer App's own status labels (`Submitted → Federation Review → Matchmaker Assigned → Approved → Deployed`) and the Web Console's Bulk Tenders labels (`Pending Review → Team Proposed → Confirmed`) are currently two independent mock-data models — they aren't wired to a shared backend yet, so the exact stage names differ between the two apps today.

## 🧩 System Architecture

```
┌─────────────────────┐   ┌─────────────────────┐   ┌──────────────────────────┐
│    Consumer App       │   │     Worker App        │   │  Cooperative Web Console  │
│   (Flutter, Dart)      │   │   (Flutter, Dart)      │   │  (React + TS + Vite)       │
└──────────┬────────────┘   └──────────┬────────────┘   └────────────┬─────────────┘
           │                            │                             │
           └────────────────────────────┴──────────────┬──────────────┘
                                                          │
                                              In-app state & mock data
                                        (ChangeNotifier session / React Context)
```

> **Current state:** each application is a self-contained front-end prototype. Role/session state is held in memory (`UserSession` `ChangeNotifier` in the Flutter apps, `AppContext` in the React console), and all services, workers, products, jobs, SOS alerts, and rate cards are backed by **local mock data** rather than a live backend, database, or external API. This is intentional for the hackathon prototype stage — see [Future Scope](#-future-scope) for the planned backend.

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| Consumer App | Flutter (Dart), Google Fonts | Cross-platform mobile app for consumers |
| Worker App | Flutter (Dart), Google Fonts | Cross-platform mobile app for the four partner roles |
| Cooperative Web Console | React 18, TypeScript, Vite, React Router | Federation/Society governance console |
| Styling (Web) | Tailwind CSS | Utility-first styling for the console |
| Icons (Web) | lucide-react | Icon set for the console UI |
| Charts (Web) | Recharts | Demand forecast & dashboard visualizations |
| State management | Flutter `ChangeNotifier` (mobile apps), React Context (`AppContext`, web) | In-memory session & role state |
| Linting | `flutter_lints` | Dart/Flutter static analysis |

## 📂 Project Structure

<details>
<summary><b>Click to expand the full repository layout</b></summary>

```
SkillsKart/
├── Consumer_App/                 # 📱 Flutter app for consumers
│   └── lib/
│       ├── Models/                # UserRole, EnterpriseRequisition, etc.
│       ├── Screens/
│       │   ├── Auth/              # Normal / Enterprise login
│       │   ├── Services/          # Trade browsing & booking
│       │   ├── Jobs/              # Local job board
│       │   ├── ProductStore/      # Artisan craft store
│       │   ├── CommunityWork/     # Community drives & events
│       │   └── Enterprise/        # Bulk booking sheet
│       ├── Services/              # UserSession (in-memory auth/session)
│       ├── Theme/                 # App-wide design tokens
│       └── Widgets/                # Shared UI components
│
├── Worker_App/                   # 👷 Flutter "Partner Portal" app
│   └── lib/
│       ├── Models/                # gig worker / seller / job / event models
│       └── Screens/
│           ├── Onboarding/        # Role selection (4 roles)
│           ├── GigWorker/
│           ├── ProductSeller/
│           ├── BusinessOwner/
│           └── CommunityOrg/
│
├── Cooperative_Web/               # 🌐 React + TS federation/society console
│   └── src/
│       ├── screens/                # Dashboard, Hierarchy, Directory, SOS,
│       │                             # RateCards, DemandForecast, BulkRequests,
│       │                             # AuditLog, Profile, Login
│       ├── components/             # Layout, Sidebar, Topbar, shared UI
│       ├── context/                # AppContext — session & scoped app state
│       └── data/                   # mockData — demo accounts, workers, alerts
│
└── README.md
```

</details>

## ⚙️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK `^3.13.2`) — for `Consumer_App` and `Worker_App`
- [Node.js](https://nodejs.org/) (v18+) and npm — for `Cooperative_Web`
- An Android/iOS simulator, connected device, or Chrome for Flutter web

### Clone the repository
```bash
git clone https://github.com/ansh-kukreja/SkillsKart.git
cd SkillsKart
```

<details open>
<summary><b>1️⃣ Consumer App</b></summary>

```bash
cd Consumer_App
flutter pub get
flutter run
```
</details>

<details>
<summary><b>2️⃣ Worker App</b></summary>

```bash
cd Worker_App
flutter pub get
flutter run
```
</details>

<details>
<summary><b>3️⃣ Cooperative Web Console</b></summary>

```bash
cd Cooperative_Web
npm install
npm run dev
```
</details>

## 🔐 Environment Variables

No `.env` file or environment variable is currently required to run any of the three applications — all data is local mock data bundled with the app (e.g. `Cooperative_Web/src/data/mockData.ts`). This section will be updated once a live backend and external services (payments, SMS/OTP, maps) are integrated.

## 🚀 Running the Project

| Order | App | Command | Notes |
|---|---|---|---|
| 1 | 📱 Consumer App | `flutter run` (inside `Consumer_App/`) | Launches on the connected device/emulator/Chrome |
| 2 | 👷 Worker App | `flutter run` (inside `Worker_App/`) | Launches on the connected device/emulator/Chrome |
| 3 | 🌐 Cooperative Web Console | `npm run dev` (inside `Cooperative_Web/`) | Starts the Vite dev server; `npm run build` produces a production bundle, `npm run preview` serves it locally |

## 🧪 Testing

- `Consumer_App/test/widget_test.dart` includes a widget test that verifies the login screen renders and the Normal/Enterprise role selection flow works.
- `Worker_App/test/widget_test.dart` is present as the default Flutter test scaffold.
- Run either with: `flutter test` from inside the respective app directory.
- The Cooperative Web Console currently has **no automated test suite** — this is an honest gap, not an oversight, and is tracked under Future Scope.

## 🔒 Security

- The Cooperative Web Console's login is a **demo/prototype flow**: it signs in using pre-defined mock Federation/Society accounts and does not perform real credential verification.
- No real authentication, encryption, or backend security layer exists yet, since there is no backend in this repository.
- No secrets, API keys, or credentials are present in the codebase.

## 🌍 Future Scope

*(Planned, not yet implemented)*

- A real backend (API + database) replacing the current in-memory/mock data across all three apps
- Real authentication (OTP/credential-based) for workers, consumers, and cooperative admins
- Live geo-location-based service matching
- Digital payments and invoicing
- Integration with worker welfare schemes (e.g. e-Shram, PMSBY, PMJJBY, PM-JAY) referenced in our research
- AI-based demand forecasting to replace the current static/mock forecast view
- Multilingual support across all three apps
- Real-time Emergency SOS dispatch pipeline between the Consumer App and Cooperative Web Console

## 🤝 Contribution

1. Fork the repository and create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes in the relevant app directory (`Consumer_App`, `Worker_App`, or `Cooperative_Web`)
3. Run `flutter analyze` / `flutter test` (Flutter apps) or `npm run build` (web console) before opening a PR
4. Commit with a clear message and open a Pull Request describing the change

## 📄 License

No license file is currently present in this repository. All rights are reserved by the project authors until a license is added.

## 👨‍💻 Team

**Team Nous Cartel**

- Gauraansh Gaur (Team Leader)
- Mohd Owais
- Rohan Prasad
- Shivam Kumar
- Priyanka Bharti
- Preet Indrapal Kukreja

---

<div align="center">

Built for **SIH26089** — Cooperative Gig Services Platform for Household & Community Services

[⬆ Back to top](#-skillskart)

</div>
