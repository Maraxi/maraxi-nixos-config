#!/usr/bin/env bash
# Find the first PCI address bound to the xHCI driver
DEV=$(ls -1 /sys/bus/pci/drivers/xhci_hcd/ | grep -E '^[0-9a-fA-F]{4}:' | head -n1)

if [ -z "$DEV" ]; then
    echo "No PCI devices found bound to xhci_hcd."
    exit 1
fi

echo "Resetting USB Host Controller: $DEV"
echo "$DEV" | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind
sleep 1.5
echo "$DEV" | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind
