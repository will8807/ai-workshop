package needs {
    import ScalarValues::String;

    requirement NEED_SYS_001 {
        attribute source : String = "problem-statement.txt:1";
        doc /* The Web Game System shall implement a containerized client-server architecture comprising a React frontend container and a FastAPI backend container. */
    }

    requirement NEED_SYS_002 {
        attribute source : String = "problem-statement.txt:3";
        doc /* The React frontend container shall use type-safe TypeScript for all user interface logic. */
    }

    requirement NEED_SYS_003 {
        attribute source : String = "problem-statement.txt:3";
        doc /* The React frontend container shall define all game states and API payloads using strict TypeScript interfaces. */
    }

    requirement NEED_SYS_004 {
        attribute source : String = "problem-statement.txt:3";
        doc /* The React frontend container shall use Bun as the package manager, test runner, and build tool. */
    }

    requirement NEED_SYS_005 {
        attribute source : String = "problem-statement.txt:3";
        doc /* The React frontend container shall use Tailwind CSS for all user interface styling. */
    }

    requirement NEED_SYS_006 {
        attribute source : String = "problem-statement.txt:4";
        doc /* The backend container shall use Python with the FastAPI framework. */
    }

    requirement NEED_SYS_007 {
        attribute source : String = "problem-statement.txt:4";
        doc /* The backend container shall use UV as the Python environment and package manager. */
    }

    requirement NEED_SYS_008 {
        attribute source : String = "problem-statement.txt:4";
        doc /* The backend container shall define all dependencies and project metadata within a pyproject.toml file. */
    }

    requirement NEED_SYS_009 {
        attribute source : String = "problem-statement.txt:4";
        doc /* The backend container shall randomly generate the computer's selection from the five game choices. */
    }

    requirement NEED_SYS_010 {
        attribute source : String = "problem-statement.txt:4";
        doc /* The backend container shall evaluate the outcome of each game round to prevent client-side manipulation. */
    }

    requirement NEED_SYS_011 {
        attribute source : String = "problem-statement.txt:5";
        doc /* The Web Game System shall provide the Containerfile for the React frontend container and the Containerfile for the FastAPI backend container. */
    }

    requirement NEED_SYS_012 {
        attribute source : String = "problem-statement.txt:6";
        doc /* The Web Game System shall provide the Kubernetes Pod manifest file named pod.yaml defining the frontend container and the backend container running in the same Pod. */
    }

    requirement NEED_SYS_013 {
        attribute source : String = "problem-statement.txt:6";
        doc /* The Kubernetes Pod manifest shall configure the host port mapping enabling external access to the React frontend container. */
    }

    requirement NEED_SYS_014 {
        attribute source : String = "problem-statement.txt:7";
        doc /* The Web Game System shall provide the Taskfile.yml defining automated tasks that build the container images, start the Pod using Podman, and stop the Pod. */
    }

    requirement NEED_SYS_015 {
        attribute source : String = "problem-statement.txt:8-18";
        doc /* The backend container shall evaluate round outcomes according to the classic Rock-Paper-Scissors-Lizard-Spock game rules. */

        requirement NEED_SYS_015_1 {
            attribute source : String = "problem-statement.txt:9";
            doc /* The backend container shall evaluate the outcome of a round as a win for Scissors and a loss for Paper when the selections are Scissors and Paper. */
        }

        requirement NEED_SYS_015_2 {
            attribute source : String = "problem-statement.txt:10";
            doc /* The backend container shall evaluate the outcome of a round as a win for Paper and a loss for Rock when the selections are Paper and Rock. */
        }

        requirement NEED_SYS_015_3 {
            attribute source : String = "problem-statement.txt:11";
            doc /* The backend container shall evaluate the outcome of a round as a win for Rock and a loss for Lizard when the selections are Rock and Lizard. */
        }

        requirement NEED_SYS_015_4 {
            attribute source : String = "problem-statement.txt:12";
            doc /* The backend container shall evaluate the outcome of a round as a win for Lizard and a loss for Spock when the selections are Lizard and Spock. */
        }

        requirement NEED_SYS_015_5 {
            attribute source : String = "problem-statement.txt:13";
            doc /* The backend container shall evaluate the outcome of a round as a win for Spock and a loss for Scissors when the selections are Spock and Scissors. */
        }

        requirement NEED_SYS_015_6 {
            attribute source : String = "problem-statement.txt:14";
            doc /* The backend container shall evaluate the outcome of a round as a win for Scissors and a loss for Lizard when the selections are Scissors and Lizard. */
        }

        requirement NEED_SYS_015_7 {
            attribute source : String = "problem-statement.txt:15";
            doc /* The backend container shall evaluate the outcome of a round as a win for Lizard and a loss for Paper when the selections are Lizard and Paper. */
        }

        requirement NEED_SYS_015_8 {
            attribute source : String = "problem-statement.txt:16";
            doc /* The backend container shall evaluate the outcome of a round as a win for Paper and a loss for Spock when the selections are Paper and Spock. */
        }

        requirement NEED_SYS_015_9 {
            attribute source : String = "problem-statement.txt:17";
            doc /* The backend container shall evaluate the outcome of a round as a win for Spock and a loss for Rock when the selections are Spock and Rock. */
        }

        requirement NEED_SYS_015_10 {
            attribute source : String = "problem-statement.txt:18";
            doc /* The backend container shall evaluate the outcome of a round as a win for Rock and a loss for Scissors when the selections are Rock and Scissors. */
        }
    }

    requirement NEED_SYS_016_1 {
        attribute source : String = "problem-statement.txt:20";
        doc /* The React frontend container shall display the initial screen presenting the starting scoreboard with 0 wins for the player. */
    }

    requirement NEED_SYS_016_2 {
        attribute source : String = "problem-statement.txt:20";
        doc /* The React frontend container shall display the initial screen presenting the starting scoreboard with 0 wins for the computer. */
    }

    requirement NEED_SYS_016_3 {
        attribute source : String = "problem-statement.txt:20";
        doc /* The React frontend container shall display the control element initiating the game round on the initial screen. */
    }

    requirement NEED_SYS_017 {
        attribute source : String = "problem-statement.txt:21";
        doc /* When the user initiates a game round, the React frontend container shall initiate a 5-second countdown timer. */
    }

    requirement NEED_SYS_018 {
        attribute source : String = "problem-statement.txt:21";
        doc /* The React frontend container shall accept the player's choice from the five game options during the countdown timer. */
    }

    requirement NEED_SYS_019 {
        attribute source : String = "problem-statement.txt:22";
        doc /* The backend container shall perform the random computer selection asynchronously during the countdown timer. */
    }

    requirement NEED_SYS_020 {
        attribute source : String = "problem-statement.txt:22";
        doc /* The React frontend container shall visually highlight the player's selection without displaying the evaluation outcome during the countdown timer. */
    }

    requirement NEED_SYS_021 {
        attribute source : String = "problem-statement.txt:23";
        doc /* When the countdown timer expires, the React frontend container shall display the player's choice and the computer's choice on the same refresh cycle. */
    }

    requirement NEED_SYS_022 {
        attribute source : String = "problem-statement.txt:24";
        doc /* The React frontend container shall display the text outcome of the evaluated round. */
    }

    requirement NEED_SYS_023 {
        attribute source : String = "problem-statement.txt:24";
        doc /* The React frontend container shall explicitly display a statement that a tie round does not increment the win count. */
    }

    requirement NEED_SYS_024 {
        attribute source : String = "problem-statement.txt:25";
        doc /* The Web Game System shall repeat game rounds until either the player or the computer reaches 2 wins. */
    }

    requirement NEED_SYS_025 {
        attribute source : String = "problem-statement.txt:26";
        doc /* When either the player or the computer reaches 2 wins, the React frontend container shall display the ultimate winner of the match with the victory or the defeat message. */
    }

    requirement NEED_SYS_026_1 {
        attribute source : String = "problem-statement.txt:26";
        doc /* When the match is completed, the React frontend container shall display the reset button. */
    }

    requirement NEED_SYS_026_2 {
        attribute source : String = "problem-statement.txt:26";
        doc /* When the user clicks the reset button, the Web Game System shall reset the match scores to zero. */
    }

    requirement NEED_SYS_026_3 {
        attribute source : String = "problem-statement.txt:26";
        doc /* When the user clicks the reset button, the Web Game System shall transition the active game state to the initial game state. */
    }
}
