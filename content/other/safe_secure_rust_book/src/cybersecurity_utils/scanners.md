### **RustScan**

- **GitHub:** [https://github.com/RustScan/RustScan](https://github.com/RustScan/RustScan)
- **Description:** RustScan is a modern port scanning tool designed to be fast and efficient. It automates the process of scanning IP addresses and ports, significantly speeding up the process compared to traditional tools like Nmap when used in conjunction. RustScan can be integrated into a cybersecurity workflow to quickly identify open ports and potential vulnerabilities in target systems.
- **Demo:**
```sh
docker pull rustscan/rustscan:2.1.1
docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -b 10000 -a 127.0.0.1
```






