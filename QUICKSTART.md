# 🚀 Quick Start Guide

## Three Ways to Use Your Game

### Option 1: Use Locally (Easiest - No Setup!)
1. Open `index.html` in any web browser
2. Start playing immediately
3. Share your screen in Teams meetings

### Option 2: Push to GitHub (Recommended)
Get your game online with free hosting!

#### For All Users:
1. Create a GitHub account at https://github.com (if you don't have one)
2. Create a new repository:
   - Go to https://github.com/new
   - Name it `teamspeak-challenge`
   - Make it PUBLIC
   - DON'T check "Initialize with README"
   - Click "Create repository"

#### For Windows Users:
1. Open Command Prompt or PowerShell in this folder
2. Run: `setup-github.bat`
3. Follow the prompts

#### For Mac/Linux Users:
1. Open Terminal in this folder
2. Run: `./setup-github.sh`
3. Follow the prompts

#### Manual Method:
```bash
# Initialize repository
git init
git add .
git commit -m "Initial commit"

# Connect to GitHub (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/teamspeak-challenge.git
git branch -M main
git push -u origin main
```

### Option 3: Enable GitHub Pages (Free Web Hosting!)

After pushing to GitHub:

1. Go to your repository on GitHub
2. Click "Settings" tab
3. Click "Pages" in the left sidebar
4. Under "Source", select "main" branch
5. Click "Save"
6. Wait 1-2 minutes
7. Your game will be live at: `https://YOUR-USERNAME.github.io/teamspeak-challenge`

🎉 **Share this URL with your team!**

## 📱 Using in Microsoft Teams

### Method 1: Screen Share
- Open the game in your browser
- Share your screen in Teams
- Play together as a team

### Method 2: Link Share (if hosted on GitHub Pages)
- Share the link in Teams chat
- Everyone opens it on their device
- Compare scores and discuss answers

### Method 3: Team Activity
- One person hosts, others answer via chat
- Rotate hosts each round
- Track team scores over time

## 🆘 Troubleshooting

### "Git is not installed"
- **Windows**: Download from https://git-scm.com/download/win
- **Mac**: Run `brew install git` or download from git-scm.com
- **Linux**: Run `sudo apt-get install git`

### "Permission denied" when pushing
- You may need to set up authentication
- Use a Personal Access Token:
  1. GitHub → Settings → Developer settings → Personal access tokens
  2. Generate new token with "repo" permissions
  3. Use token as password when pushing

### Game not loading on GitHub Pages
- Wait 2-3 minutes after enabling Pages
- Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)
- Check that repository is PUBLIC

## 📧 Need Help?

Check the full documentation:
- `README.md` - Complete project documentation
- `DEPLOYMENT.md` - Detailed deployment guide

## 💡 Quick Tips

1. **Customize**: Edit `index.html` to add your own questions
2. **Update**: After changes, commit and push:
   ```bash
   git add .
   git commit -m "Add new questions"
   git push
   ```
3. **Share**: Send the GitHub Pages URL to anyone
4. **Track**: Use GitHub's built-in activity tracking

---

**Ready to start?** Just open `index.html` and play! 🎮
