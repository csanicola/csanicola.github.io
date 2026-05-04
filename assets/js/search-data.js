// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "about",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-blog",
          title: "blog",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/blog/";
          },
        },{id: "nav-publications",
          title: "publications",
          description: "publications by categories in reversed chronological order.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/publications/";
          },
        },{id: "nav-projects",
          title: "projects",
          description: "A collection of personal and work projects that showcase my skills.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/projects/";
          },
        },{id: "nav-repositories",
          title: "repositories",
          description: "An overview of my work and personal github repo&#39;s.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/repositories/";
          },
        },{id: "nav-resources",
          title: "resources",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/resource-portal/";
          },
        },{id: "nav-cv",
          title: "cv",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "dropdown-bookshelf",
              title: "bookshelf",
              description: "",
              section: "Dropdown",
              handler: () => {
                window.location.href = "/books/";
              },
            },{id: "dropdown-news",
              title: "news",
              description: "",
              section: "Dropdown",
              handler: () => {
                window.location.href = "/news/";
              },
            },{id: "post-will-ai-change-human-speech-and-incorrectly-define-humanity-going-forward",
        
          title: "Will AI change human speech and incorrectly define humanity going forward?",
        
        description: "Just like with &quot;slang&quot;, we could start seeing new vernacular catered to prompts for AI.",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/Will-AI-change-human-speech-and-incorrectly-define-humanity-going-forward/";
          
        },
      },{id: "post-writing-habit-transformation-day-02",
        
          title: "Writing Habit Transformation - Day 02",
        
        description: "not writing everyday is not a failure",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/Day-02/";
          
        },
      },{id: "post-writing-habit-transformation-day-01",
        
          title: "Writing Habit Transformation - Day 01",
        
        description: "Working on Improving My Writing By Writing More",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2026/Day-01/";
          
        },
      },{id: "post-what-i-learned-this-week",
        
          title: "What I Learned This Week",
        
        description: "what i learned this week",
        section: "Posts",
        handler: () => {
          
            window.location.href = "/blog/2025/what-i-learned-this-week/";
          
        },
      },{id: "books-second-foundation",
          title: 'Second Foundation',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/second_foundation/";
            },},{id: "books-butter",
          title: 'Butter',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/butter/";
            },},{id: "books-into-the-wild",
          title: 'Into the Wild',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/into_the_wild/";
            },},{id: "books-katabasis",
          title: 'Katabasis',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/katabasis/";
            },},{id: "books-the-frozen-river",
          title: 'The Frozen River',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/the_frozen_river/";
            },},{id: "books-project-hail-mary",
          title: 'Project Hail Mary',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/project_hail_mary/";
            },},{id: "books-yesteryear",
          title: 'Yesteryear',
          description: "",
          section: "Books",handler: () => {
              window.location.href = "/books/yesteryear/";
            },},{id: "news-this-website-is-now-live-i-m-still-working-on-it-and-will-be-adding-more-content-as-i-go-along",
          title: 'This website is now live! I’m still working on it and will be...',
          description: "",
          section: "News",},{id: "news-the-resource-portal-is-coming-soon",
          title: 'The Resource Portal is coming soon!',
          description: "",
          section: "News",handler: () => {
              window.location.href = "/news/announcement_2/";
            },},{id: "projects-project-1",
          title: 'project 1',
          description: "with background image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/1_project/";
            },},{id: "projects-project-2",
          title: 'project 2',
          description: "a project with a background image and giscus comments",
          section: "Projects",handler: () => {
              window.location.href = "/projects/2_project/";
            },},{id: "projects-project-3-with-very-long-name",
          title: 'project 3 with very long name',
          description: "a project that redirects to another website",
          section: "Projects",handler: () => {
              window.location.href = "/projects/3_project/";
            },},{id: "projects-project-4",
          title: 'project 4',
          description: "another without an image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/4_project/";
            },},{id: "projects-project-5",
          title: 'project 5',
          description: "a project with a background image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/5_project/";
            },},{id: "projects-project-6",
          title: 'project 6',
          description: "a project with no image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/6_project/";
            },},{id: "projects-project-7",
          title: 'project 7',
          description: "with background image",
          section: "Projects",handler: () => {
              window.location.href = "/projects/7_project/";
            },},{id: "projects-project-8",
          title: 'project 8',
          description: "an other project with a background image and giscus comments",
          section: "Projects",handler: () => {
              window.location.href = "/projects/8_project/";
            },},{id: "projects-project-9",
          title: 'project 9',
          description: "another project with an image 🎉",
          section: "Projects",handler: () => {
              window.location.href = "/projects/9_project/";
            },},{
        id: 'social-email',
        title: 'email',
        section: 'Socials',
        handler: () => {
          window.open("mailto:%63%61%72%6F%6C%69%6E%65%73%61%6E%69%63%6F%6C%61@%67%6D%61%69%6C.%63%6F%6D", "_blank");
        },
      },{
        id: 'social-github',
        title: 'GitHub',
        section: 'Socials',
        handler: () => {
          window.open("https://github.com/csanicola", "_blank");
        },
      },{
        id: 'social-linkedin',
        title: 'LinkedIn',
        section: 'Socials',
        handler: () => {
          window.open("https://www.linkedin.com/in/caroline-sanicola", "_blank");
        },
      },{
        id: 'social-orcid',
        title: 'ORCID',
        section: 'Socials',
        handler: () => {
          window.open("https://orcid.org/0000-0002-0744-3344", "_blank");
        },
      },{
        id: 'social-rss',
        title: 'RSS Feed',
        section: 'Socials',
        handler: () => {
          window.open("/feed.xml", "_blank");
        },
      },{
        id: 'social-spotify',
        title: 'Spotify',
        section: 'Socials',
        handler: () => {
          window.open("https://open.spotify.com/user/csanicola74", "_blank");
        },
      },{
      id: 'light-theme',
      title: 'Change theme to light',
      description: 'Change the theme of the site to Light',
      section: 'Theme',
      handler: () => {
        setThemeSetting("light");
      },
    },
    {
      id: 'dark-theme',
      title: 'Change theme to dark',
      description: 'Change the theme of the site to Dark',
      section: 'Theme',
      handler: () => {
        setThemeSetting("dark");
      },
    },
    {
      id: 'system-theme',
      title: 'Use system default theme',
      description: 'Change the theme of the site to System Default',
      section: 'Theme',
      handler: () => {
        setThemeSetting("system");
      },
    },];
