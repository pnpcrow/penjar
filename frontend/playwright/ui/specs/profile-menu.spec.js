import { test, expect } from "@playwright/test";
import DashboardPage from "../pages/DashboardPage";

test.beforeEach(async ({ page }) => {
  await DashboardPage.init(page);
});

test("Navigate to penjar changelog from profile menu", async ({ page }) => {
  const dashboardPage = new DashboardPage(page);
  await dashboardPage.goToDashboard();

  await dashboardPage.openProfileMenu();
  await dashboardPage.clickProfileMenuItem("About Penjar");

  // Listen for the new page (tab) that opens when clicking "Penjar Changelog"
  const [newPage] = await Promise.all([
    page.context().waitForEvent("page"),
    dashboardPage.clickProfileMenuItem("Penjar Changelog"),
  ]);

  await newPage.waitForLoadState();
  await expect(newPage).toHaveURL(
    "https://github.com/penjar/penjar/blob/develop/CHANGES.md",
  );
});

test("Opens release notes from current version from profile menu", async ({
  page,
}) => {
  const dashboardPage = new DashboardPage(page);
  await dashboardPage.goToDashboard();

  await dashboardPage.openProfileMenu();
  await dashboardPage.clickProfileMenuItem("About Penjar");
  await expect(page.getByText("Version 0.0.0 notes")).toBeVisible();
  await dashboardPage.clickProfileMenuItem("Version");
  await expect(page.getByText("new in penjar?")).toBeVisible();
});
